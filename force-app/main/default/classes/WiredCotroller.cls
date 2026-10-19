public class WiredCotroller {

    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccounts(){
        List<Account> lstAcc=[SELECT Id,Name,Rating,Industry,Phone FROM Account LIMIT 9];
        return lstAcc;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> fetchContacts(Boolean flag){
        return [SELECT Id,FirstName,LastName,Email FROM Contact Limit 5];
    }
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> fetchOpportunities(Boolean flag){
        return [SELECT Id,StageName,Name FROM Opportunity Limit 5];
    }
}