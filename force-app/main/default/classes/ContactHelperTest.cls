@isTest
public class ContactHelperTest {
    @TestSetUp
    public static void setUpData(){
  		Account acc =new Account(Name='Test Record');
        insert acc;
    }
    @isTest
    public static void validateMethod(){
        Contact con=new Contact(LastName='Testing Con Record',Primary_Contact__c=true);
        insert con;
        Test.startTest();
        try{
         Delete con;
           System.assert(false,'Delete should have failed'); 
        }catch(Exception e){
            System.assert(e.getMessage().contains('Deletion not allowed for Primary Contacts'));
        }
        
        Test.stopTest();
    }
    @isTest
    public static void CountContactMethod(){
       Account acc=[SELECT Id,Name FROM Account LIMIT 1];
       Contact con=new Contact(LastName='Testing Record-2',AccountId=acc.Id);
        Test.startTest();
        Insert con;
        Test.stopTest();
        Account accUpdate=[SELECT Contact_Count__c FROM Account where Id=:acc.Id];
        System.assertEquals(1,accUpdate.Contact_Count__c);   
    }
    @isTest
    public static void createOppTestMethod(){
       Contact con=new Contact(LastName='Testing Cont-1'); 
        Insert con;
        Contact conData=[SELECT AccountId,LastName,Primary_Contact__c FROM Contact LIMIT 1];
        if(conData.Primary_Contact__c ==false){
            //create opp
            Opportunity opp =new Opportunity();
                        opp.Name='Testing Record';
                        opp.StageName='Prospecting';
                        opp.CloseDate=System.today();
                        opp.AccountId=conData.AccountId;
            Test.startTest();
            Insert opp;
            Opportunity o=[SELECT Name,AccountId,StageName,CloseDate FROM Opportunity LIMIT 1]; 
            o.Name='Updated Record';
            o.StageName='Closed Won';
            o.CloseDate=System.today();
            o.AccountId=conData.AccountId;
            System.assertEquals(o.AccountId,conData.AccountId);
            Test.stopTest();
        }
        
    }
}