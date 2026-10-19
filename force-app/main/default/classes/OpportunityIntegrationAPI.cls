//Exposing the Apex Class as Rest API Class
//* -- anything can come after this one ,either record or id  
@RestResource(urlMapping='/external/opportunities/*')
global with sharing class OpportunityIntegrationAPI {
  
    //Execute when post man sends the data 
    //and return the result to post man simply records created like that
    @HTTPPost
    global static String getOpportunities(){
        //Getting the Request from postman
        RestRequest request=RestContext.request;
        //getting the body from post man
        String body=request.requestBody.toString();
        //Converting the JSON Data into Apex data and Storing inside the Opportunity
        List<Opportunity>oppRecords= (List<Opportunity>)JSON.deserialize(body,List<Opportunity>.class);
        //Processing the Records Partially
        //false --> To allow the Partial Mechanisum
        Database.SaveResult[]result=Database.Insert(oppRecords,false);
        Integer successCount=0;
        Integer failureCounts=0;
        for(Database.SaveResult res:result){
            if(res.isSuccess()){
                successCount++;
            }else {
                failureCounts++;
            }
        }
        
        return 'Total Records'+oppRecords.size()+ ' Success Records Count: '+successCount+' Failure Records Count'+ failureCounts;
    }
}