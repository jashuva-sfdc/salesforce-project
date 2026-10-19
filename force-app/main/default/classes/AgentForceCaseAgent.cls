public without sharing class AgentForceCaseAgent {
  
    @InvocableMethod(label='Case Status' description='Fetching the Case Status Based on Case Number.')
    public static List<String> fetchStatus(List<String> caseNumbers){

        if(caseNumbers == null || caseNumbers.isEmpty()){
            return new List<String>{'Case Number is required.'};
        }

        List<Case> cases = [SELECT  Status FROM Case WHERE CaseNumber =: caseNumbers[0] LIMIT 1];
        if(!cases.isEmpty()){
            return new List<String>{cases[0].Status};
        }
        return new List<String>{'Case Number is Invalid.'};
    }
  
    //for better efficency 2 method copy of the 1st one 
    public static List<String> fetchData(List<String> caseNumber){
        if(caseNumber ==null || caseNumber.isEmpty()){
            return new List<String>{'Case Number is Required'};
        }
        //Fetching the Case Status based on the number
        List<Case> caseStatus =[Select Status From Case Where CaseNumber IN : caseNumber];
        
        //Add into the Map Collections for bulkifying i.e entering the Group of Case Numbers Only I want Matched Data
        Map<String,String> matchedCase =new Map<String,String>();
        for(Case cs:caseStatus){
            if(cs.CaseNumber != null){
             matchedCase.put(cs.CaseNumber,cs.Status);   
            }
        }
        List<String> result =new List<String>();
        //Check the case Number then add it into the list then return the list
        for(String cn:caseNumber){
            if(matchedCase.containsKey(cn)){
               result.add(cn+':'+matchedCase.get(cn));
            }else{
                result.add(cn+' Case Number is Not Valid');
            }
        }
        return result;
    }
}