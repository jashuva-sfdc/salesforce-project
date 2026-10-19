@isTest
public class LeadHandlerTest {

    @isTest
    public static void leadConvertionTest(){
        Lead ld=new Lead();
        ld.FirstName='Testing';
        ld.Company='Test Compnay';
        ld.LastName='Lead';
        ld.Phone='8884447771';
        ld.Status='Open - Not Contacted';
        ld.Age__c=25;
		insert ld;
        LeadStatus ldStatus=[SELECT Id,MasterLabel,IsConverted FROM LeadStatus WHERE IsConverted=TRUE LIMIT 1];
        
        Database.leadConvert ldConvert=new Database.leadConvert();
        ldConvert.setLeadId(ld.Id);
        ldConvert.setConvertedStatus(ldStatus.MasterLabel);
        ldConvert.setDoNotCreateOpportunity(true);
        
        Test.startTest();
        Database.leadConvertResult result=Database.convertLead(ldConvert);
        Test.stopTest();
        System.assert(result.isSuccess(),'Lead Converted Successfully');
        
        //Check the values in Account whether they are created or not 
        Account acc=[SELECT Id,Name FROM Account where Id =:result.getAccountId()];
        System.assertEquals('Custom Name',acc.Name);
        
        Contact con=[Select Id,LastName FROM Contact where Id =:result.getContactId()];
        System.assertEquals('Created By Apex',con.LastName);
        
    }
}