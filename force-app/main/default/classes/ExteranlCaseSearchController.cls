public class ExteranlCaseSearchController {

    //These fields values are going to return to lwc, not storing inside the ORG A
    public class CaseResult{
        //these properties or variables are exposed to lightning components,later we can use them 
       @AuraEnabled public String Id {set;get;} 
       @AuraEnabled public String caseNumber {set;get;}
       @AuraEnabled public String caseStatus{set;get;}
       @AuraEnabled public String caseOrigin{set;get;}
       @AuraEnabled public String caseSubject {set;get;}
       @AuraEnabled public String casePriority{set;get;}
       @AuraEnabled public String caseDescription {set;get;}
    }
    @AuraEnabled
    public static List<CaseResult> getCaseDetails(String caseStatus,String casePriority,String caseOrigin){
        //Back slash we are using to contain names like that John's  If name contains single quote it should add same like as
        String soqlQuery ='SELECT Id,CaseNumber,Status,Priority,Origin,Subject,Descritption FROM Case'
            				+'WHERE Status = \''+String.escapeSingleQuotes(caseStatus)+'\''
            				+'AND'+'\''+ String.escapeSingleQuotes(casePriority)+'\''+'AND'+'\''+String.escapeSingleQuotes(caseOrigin)+'\'';
        
        //send the code to exteranl system only fetch these details from case 
        String encodedQuery=EncodingUtil.urlEncode(soqlQuery,'UTF-8');
        String endPoint ='callout:Org_B_Case_Search_API/services/data/v64.0/query?q='+encodedQuery;
        
        //Intiate the Protocol and request and response
       	HTTP protocol =new HTTP ();
        HttpRequest request =new HttpRequest();
        request.setMethod('GET');
        request.setEndPoint(endPoint);
        request.setTimeout(120000);
        
        HttpResponse response;
        try{
            response=protocol.send(request);
            
        }catch(Exception ex ){
            throw new AuraHandledException('Call out ORG B failed '+ex.getMessage());
        }
        //check the status code
        if(response.getStatusCode() !=200){
            throw new AuraHandledException('ORG B Connection Failed ,Status Code Is :'+response.getStatusCode());
        }
        //convert the resopnse into apex data payload --> data
        Map<String,Object>payload=(Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        
        //after getting the data into map,separating the  records  
        List<Object> records = (List<Object>)payload.get('records');
        
        //Iterate the "records" and give those values to Wrapper class ("CaseResult") variables
        List<CaseResult> result =new List<CaseResult>();
        for(Object objRecords:records){
            //again converting the records into map later fetching the exact field values from Map using "get()"
            Map<String,Object> record=(Map<String,Object>)objRecords;
            CaseResult cs =new CaseResult();
            cs.Id=(String)record.get('Id'); //these are all returning from ORG B and we are making the SOQL Query reference 
            cs.caseNumber=(String) record.get('CaseNumber');
            cs.caseStatus=(String)record.get('Status');
            cs.casePriority=(String)record.get('Priority');
            cs.caseOrigin =(String)record.get('Origin');
            cs.caseSubject =(String)record.get('Subject');
            cs.caseDescription =(String)record.get('Description');
            
            result.add(cs);
        }
        return result;
        
    }
}