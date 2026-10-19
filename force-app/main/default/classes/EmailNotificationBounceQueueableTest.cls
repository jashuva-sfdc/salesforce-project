@isTest
public class EmailNotificationBounceQueueableTest {
    @isTest
    public static void testQueueable(){
        //Once Email Is Crated if it is Bounced then send the Case with owner record Email 
        //--> Create User First 
        Profile adimnProfile=[SELECT Id,Name From Profile Where Name='System Administrator' Limit 1];
        
        Case cs =new Case(Status='New',Description='Test Description',Origin='Phone');
        Insert cs;
        EmailMessage email =new EmailMessage(parentId=cs.Id,subject='Email Testing Subject',
                                             TextBody='Email Body',ToAddress='test@gmail.com');
        insert email;
        
    }
}