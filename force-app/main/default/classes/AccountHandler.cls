public class AccountHandler {
    public static void updateContact(List<Account>lstAcc,Map<Id,Account>mapOldAcc){
        //when an account Billing City is Updated then updating Contact Mailing City
        Set<Id> accId =new Set<Id>();
        if(lstAcc !=null){
           for(Account acc:lstAcc){
               Account oldData=mapOldAcc.get(acc.Id);
                   if(acc.BillingCity !=null && acc.BillingCity !=oldData.BillingCity){
                       accId.add(acc.Id);
                   }
        	} 
            
            //get the data from contact which is releated to Account 
            List<Contact> conUpdate=[SELECT AccountId,MailingCity,Phone FROM Contact where AccountId IN: accId];
            
            //Converting the list into map collection to get the current data & make efficient
            Map<Id,Account> mapAcc =new Map<Id,Account>(lstAcc);
            for(Contact con:conUpdate){
                //bcz of the map we are getting the data where it is matches the same Account record ID
                Account accData=mapAcc.get(con.AccountId);
                con.MailingCity =accData.BillingCity;
                con.Phone=accData.Phone;
            }
            if(!conUpdate.isEmpty()){
                update conUpdate;
            }
        }
        
    }

    //This Method Consdiered as Controller method  PUBLSIHER RESULT
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecords(){

        List<Account> accRecords=[SELECT Id,Name FROM Account limit 10];
        return accRecords;
    }

    //THIS METHOD IS USED FOR SUBSCRIBER
    @AuraEnabled 
    public static List<Account> accountDetails(Id accountRecordId){
        List<Account> accDetails=[SELECT Id,Name,Rating,Industry FROM
                                  Account WHERE Id =:accountRecordId];
        return accDetails;
    }
    
    public static void reAssignProductComplaint(List<Account> lstAccount){
        
        //STEP  -1 collect the nefore deleting account id 
        Set<Id> accDeleteId =new Set<Id>();
        for(Account acc:lstAccount){
          accDeleteId.add(acc.Id);   
        }
        // STEP -2 Fetch the Related Product Complaint Records
        List<Product_Complaint__c> prodDetails =[SELECT Account__c,Id,Name FROM Product_Complaint__c WHERE Account__c IN:accDeleteId];
        
        //GET THE Account records those details not deleted in Account 
       	Map<Id,Account> existingAccounts=new Map<Id,Account>([SELECT Id,Name FROM Account WHERE Id NOT IN:accDeleteId]);
        
        for(Product_Complaint__c complaint :prodDetails){
            Account acc=existingAccounts.get(complaint.Account__c);
            complaint.Account__c=acc.Id;
        }
        update prodDetails;
    }
}