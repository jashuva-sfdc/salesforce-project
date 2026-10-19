public class OpportunityHelper {
    
    //when an oppoprutnity stage as closed won create an agreement 
    public static void createAgreement(List<Opportunity>lstOpp,Map<Id,Opportunity>mapOpp){
        if(lstOpp !=null){
            List<Agreement__c> lstAg=new List<Agreement__c>();
            for(Opportunity newOpp:lstOpp){
                Opportunity oldOpp=mapOpp.get(newOpp.Id);
                //which means when ever the stage is changed to closed won then only create agreement .If the stage is same closed won then no need to create agrreement alreday having the agreement
                if(oldOpp.StageName !='Closed Won' && newOpp.StageName == 'Closed Won')
                {
                    //create an agreement 
                    Agreement__c ag=new Agreement__c();
                    ag.Agreement_Start_Date__c=System.today();
                    ag.Agreement_Period__c='1 Year';
                    ag.Agreement_Value__c=25000;
                    ag.Opportunity__c=newOpp.Id;
                    lstAg.add(ag);
                }
            }
            if(!lstAg.isEmpty()){
                Insert lstAg;
            }  
            
        }
    }
    //When oppotunity stage is clsed then update the closed date in Account
    public static void updateAccountField(List<Opportunity> lstOpp,Map<Id,Opportunity>oppMap){
        if(lstOpp !=null){
            Set<Id>accRelId=new Set<Id>();
            for(Opportunity opp:lstOpp){
                Opportunity oldData=oppMap.get(opp.Id);
                if(opp.IsClosed ==true && opp.CloseDate !=oldData.CloseDate && opp.AccountId !=Null){
                    accRelId.add(opp.AccountId);
                }
            }
            //Get all Opportunites are closed with Accounts
            List<Opportunity> closedOpp=[SELECT AccountId,CloseDate,IsClosed FROM Opportunity 
                                         where AccountId IN: accRelId AND 
                                         CloseDate !=null AND IsClosed=TRUE];
            //add accountId and Date into map c
            Map<Id,Date> latestClosedAcc=new Map<Id,Date>();
            for(Opportunity opp:closedOpp){
                if(!latestClosedAcc.containsKey(opp.AccountId) || opp.CloseDate > latestClosedAcc.get(opp.AccountId)){
                    //add into the map
                    latestClosedAcc.put(opp.AccountId,opp.CloseDate);
                }
            }  
            
            List<Account>accToUpdate =new List<Account>();
            for(Id accId:latestClosedAcc.keySet()){
                Account acc=new Account(Id=accId,
                                        Last_Opportunity_Close_Date__c=latestClosedAcc.get(accId));
                accToUpdate.add(acc);
            }
            if(!accToUpdate.isEmpty()){
                update accToUpdate;
            } 
        }
    }
}