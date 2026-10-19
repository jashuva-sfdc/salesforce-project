public  class CandidateHandler {
    @AuraEnabled(cacheable=true)
   public static List<Candidate__c> getCandidates(){
     List<Candidate__c> lstCand=[SELECT Id,Name,LastName__c,Email_Address__c,Phone_Number__c FROM Candidate__c LIMIT 10];
    return lstCand;
   }
}