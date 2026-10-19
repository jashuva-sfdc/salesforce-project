public class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountDetails(){
        List<Account> accDetails =[SELECT Id,Name,Phone,AnnualRevenue ,Industry FROM Account];
        return accDetails;
    }
    
    @AuraEnabled
    public static void updateAccountDetails(List<Account> accounts){
         update accounts;
    }
}