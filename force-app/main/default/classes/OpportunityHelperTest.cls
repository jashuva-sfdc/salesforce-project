@isTest
public class OpportunityHelperTest {

    @isTest
    public static void testCreateAgreemetMethod(){
        Opportunity opp =new Opportunity();
                            opp.Name='Testing Record';
                            opp.StageName='Prospecting';
                            opp.CloseDate=System.today();
        Insert opp;
      Opportunity opp2=[SELECT Id,Name,StageName,AccountId FROM Opportunity LIMIT 1]; 
        if(opp.StageName =='Closed Won'){
             Agreement__c ag=new Agreement__c();
                    ag.Agreement_Start_Date__c=System.today();
                    ag.Agreement_Period__c='1 Year';
                    ag.Agreement_Value__c=25000;
                    ag.Opportunity__c=opp2.Id;
            
            Test.startTest();
            insert ag;
            Test.stopTest();
            
        }
    }
    @isTest
    public static void testUpdateAccountField(){
        Account acc =new Account(Name='Test Account Record');
         Insert acc;
        Opportunity opp =new Opportunity(Name='Test Record',
                                         CloseDate=System.today(),
                                        StageName='Prospect', AccountId=acc.Id);
        Insert opp;
        Test.startTest();
        opp.StageName ='Closed Won';
        update opp;
		Date currentDate =system.today();
		Date nextMonthDate =currentDate.addMonths(1);
        opp.CloseDate=nextMonthDate;
        update opp;
        Test.stopTest();
        Account updatedAcc=[SELECT Id,Last_Opportunity_Close_Date__c FROM Account LIMIT 1];
        System.assertEquals(updatedAcc.Last_Opportunity_Close_Date__c,opp.CloseDate);
    }
}