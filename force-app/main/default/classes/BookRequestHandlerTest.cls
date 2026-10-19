@isTest
public class BookRequestHandlerTest {
    @TestSetUp
    public static void setUpDadta(){
        Profile pr =[SELECT Id,Name FROM Profile Where Name ='System Administrator' LIMIT 1]; 
        //create 2 users, Principal AND Library
         // Principal User
        User principal = new User(FirstName = 'Principal',LastName = 'User',Alias = 'princ',Email = 'principal@test.com',
            Username = 'principal' + System.currentTimeMillis() + '@test.com',ProfileId = pr.Id,TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US'
        );
        insert principal;
                // Library User
        User librarian = new User(FirstName = 'Library',LastName = 'User',Alias = 'libusr', Email = 'library@test.com', Username = 'library' 
                                  + System.currentTimeMillis() + '@test.com',ProfileId = pr.Id,TimeZoneSidKey = 'Asia/Kolkata', 
                                  LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        insert librarian;
        System.runAs(principal){
            Book__c bk =new Book__c(Name='Test Book');
            insert bk;
        }   
    }
    @isTest
    public static void shareRecordToBook(){
       //Fetch The Users 
       User libraryUser =[SELECT Id,Alias FROM User WHERE Alias='libusr' LIMIT 1]; 
       User principalUser=[SELECT Id,Alias FROM User WHERE Alias='princ' LIMIT 1]; 
       Book__c bk =[SELECT Id,OwnerId FROM Book__c LIMIT 1]; 
        System.runAs(libraryUser){
         //Create Book Request Record with Current User
         Book_Request__c br =new Book_Request__c(Book__c=bk.Id, Status__c='Approved');
            Test.startTest();
            insert br;
            Test.stopTest();
        
        //Get The Share Object Details;
        Book_Request__Share share=[SELECT ParentId,UserOrGroupId,AccessLevel,RowCause FROM Book_Request__Share LIMIT 1];
        
            //Check the Status whether code is executing perfectly or not and Expected value and Actual Value
            //First Parameter Expected Value ,Second One is Actual Value	If both are matching it will returns as TRUE Else False 
             System.assertEquals(br.Id,share.ParentId); 
             System.assertEquals(principalUser.Id,share.UserOrGroupId);
             System.assertEquals('Edit',share.AccessLevel);
             System.assertEquals('Manual',share.RowCause);
        }
    }
}