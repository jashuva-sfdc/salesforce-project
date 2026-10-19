@isTest
public class ContactHandlerTest {

    @TestSetUp
    public static void testSetUp(){
        //Step -1 create Account 
       
        //Step -3 create contact and update the contact
        Account acc =new Account(Name='Test Record');
        insert acc;
    }
    @isTest
    public static void testUpdateNamesOnCreation(){
         //Step -2 Create Contact with that Account
       Account ac=[SELECT Id,Name,Contact_Names__c FROM Account LIMIT 1];
        Contact con =new Contact (LastName='Test Cont',AccountId=ac.Id);
        
        Test.startTest();
        insert con;
        Test.stopTest();
        Account accToUpdate=[Select Id,Contact_Names__c FROM Account where Id=:ac.Id LIMIT 1];
        System.assertEquals('Test Cont',accToUpdate.Contact_Names__c);
    }
    @isTest
    public static void testUpdateNamesOnUpdation(){
        
        //Fetch Account 
        Account acc =[SELECT Id FROM Account LIMIT 1];
        
        //Create Contact with Account
        Contact con=new Contact(LastName='David',AccountId=acc.Id);
        Insert con;
        //update contact
        Test.startTest();
        con.LastName='JOHN';
        update con;
        Test.stopTest();
        Account accToUpdate=[Select Id,Contact_Names__c FROM Account where Id=:acc.Id LIMIT 1];
        System.assertEquals('JOHN',accToUpdate.Contact_Names__c);
    }
}