public class OpportunityHandler {

    public static void sumOfOpportunity(List<Opportunity> lstOpp,Map<Id,Opportunity> oldMap){
        if(lstOpp !=null){
            //Releated Account Id 
            Set<Id> accRelId =new Set<Id>();
            if(oldMap ==null){
                 for(Opportunity opp:lstOpp){
                if(opp.AccountId !=null){
                    accRelId.add(opp.AccountId);
                }
              }
            }else {
                  for(Opportunity opp:lstOpp){
                      Opportunity oppOld=oldMap.get(opp.Id);
                      if( oppOld !=null && opp.AccountId !=oppOld.AccountId ){
                      if(opp.AccountId !=null){
                      	accRelId.add(opp.AccountId);  
                      }
                         if(oppOld.AccountId !=null){
                           accRelId.add(oppOld.AccountId);  
                         }
                	}
              }
           
            
            //Fetch the Releated Data from Opp
            Map<Id,Decimal> sumOppAmount =new Map<Id,Decimal>();
            
            for(AggregateResult ar:[SELECT AccountId acc, Sum(Amount) totalSum FROM
                                   Opportunity
                                   Where AccountId IN: accRelId
                                   Group by AccountId]){
                sumOppAmount.put((Id)ar.get('acc'),(Decimal)ar.get('totalSum'));
            }
            //update in Account 
            List<Account> lstAccUpdate =new List<Account>();
            Decimal totalAmount=0;
            for(Id oppId:sumOppAmount.keySet()){
                if(sumOppAmount.containsKey(oppId)){
                     totalAmount=sumOppAmount.get(oppId);
                    lstAccUpdate.add(
                     new Account(Id=oppId,
                                 Total_Opportunity_Amount__c=totalAmount)
                    );
                }
            }
            if(!lstAccUpdate.isEmpty()){
                update lstAccUpdate;
            }
        }
        }
        
        
    }
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> opportunityList(){
        List<Opportunity> lstOpp=[SELECT Id,Name FROM Opportunity LIMIT 5];
        return lstOpp;
    }
    @AuraEnabled(cacheable=true)	
    public static List<Opportunity> getAllDetails(Id opportunityId){
        List<Opportunity> lstDetails =[SELECT Id,Name,StageName,Amount FROM Opportunity
                                      where Id=: opportunityId];
        return lstDetails;
    }
    
    //Whenever opp stage is updated to Closed won then update in Account custom fields
    public static void updateAccount(List<Opportunity>newList,Map<Id,Opportunity>oldMap){
       
        Set<Id> accRelId =new Set<Id>();
        for(Opportunity newOpp:newList){
            if(newOpp.AccountId !=null){
                Opportunity oldOpp=oldMap.get(newOpp.Id);
                if(newOpp.StageName =='Closed Won' && newOpp.StageName !=oldOpp.StageName){
                    accRelId.add(newOpp.AccountId);
                }
            }
        }
        
       List<Account> accUpdate =new List<Account>();
        for(Id accId :accRelId){
           Account acc
               
               =new Account(
           						Id=accId,
               					Opportunity_Closed_Won__c=true,
               					Last_Updated_Date__c=System.today()
           					); 
            accUpdate.add(acc);
        }
        if(!accUpdate.isEmpty()){
           update accUpdate; 
        }
    } 
    
    //whenever opportunity is created then updapte account name in contact
    public static void updateContactLastName(List<Opportunity> newOpp){
        
        Set<Id> accRelId =new Set<Id>();
        for(Opportunity opp:newOpp){
            if(opp.AccountId !=null){
                accRelId.add(opp.AccountId);
            } 
        }
        
        //Fetch The Account Name To Update in Contact with lastName
        Map<Id,Account> accMap=new Map<Id,Account>([SELECT Id,Name FROM Account where Id IN:accRelId]);
        
        //Update In Contact
        List<Contact> updateCont=[SELECT AccountId,LastName FROM Contact Where AccountId IN:accRelId];
        for(Contact con:updateCont){
            Account accData =accMap.get(con.AccountId);
            con.LastName=accData.Name;
        }
        if(!updateCont.isEmpty()){
           update updateCont; 
        }
    }
    
    //update the OPEN OPP Count AND CLOSED OPP Count
    public static void updateOpenClosedOpp(List<Opportunity> newOpp,Map<Id,Opportunity> oldMap){
        
        Set<Id> accId =new Set<Id>();
        for(Opportunity opp:newOpp){
            if(opp.AccountId !=null){
                if(opp.StageName !='Closed Won'){
                    accId.add(opp.AccountId);
                }
                if(opp.StageName=='Closed Won'){
                     accId.add(opp.AccountId);
                }
            }
        }
        Map<Id,Integer> oppOpenStage =new Map<Id,Integer>();
        Map<Id,Integer> oppClosedStage =new Map<Id,Integer>();
        for(AggregateResult ar:[SELECT AccountId accRelId,StageName oppStage,Count(Id) totalCount FROM Opportunity where AccountId IN:accId
                               Group By AccountId,StageName]){
            //Get the data and add inside the map
           Id accountRelId=(Id) ar.get('accRelId');
		   String stageName=(String)ar.get('oppStage');
		   Integer countOpp=(Integer)ar.get('totalCount');
            if(stageName !='Closed Won'){
                oppOpenStage.put(accountRelId,countOpp);                       
            }else if(stageName =='Closed Won'){
                oppOpenStage.put(accountRelId,countOpp);                   
            }
                                   
        }
        //update inside the Account
		List<Account> updateAccount =[SELECT Id,Closed_Opportunites__c,Open_Opportunities__c FROM Account where Id IN:accId];
        for(Account acc:updateAccount){
            
           acc.Open_Opportunities__c=oppOpenStage.containsKey(acc.Id)? oppOpenStage.get(acc.Id):0 ;
            acc.Closed_Opportunites__c=oppOpenStage.containsKey(acc.Id)? oppOpenStage.get(acc.Id):0 ;
        }
        if(!updateAccount.isEmpty()){
            update updateAccount;
        }
    }
    //if there are any  existing opportunites are associated with Account within the 24 hours then don't allow to create opp with acc 
    //after 24 hours time then only allow 
    public static void preventChoosingOpp(List<Opportunity>lstOpp){
        if(lstOpp !=NULL){
            //collect the related acc id 
            Set<Id> accRelId =new Set<Id>();
            for(Opportunity opp:lstOpp){
                if(opp.AccountId !=NULL){
                    accRelId.add(opp.AccountId);
                }
            }
            
            //calculate the 24- hour cut off 
            DateTime cutOffTime =System.now().addHours(-24);
            
            //findout any existing opp records are associated with Accounts 
            //If exist add those records into se
            Set<Id> existingAccounts=new Set<Id>();
            for(Opportunity opp:[SELECT Id,AccountId,CreatedDate FROM Opportunity Where AccountId IN: accRelId 
                                AND CreatedDate >= :cutOffTime]){
                existingAccounts.add(opp.AccountId);
            }
            //validate for new records
            for(Opportunity opp:lstOpp){
                if(existingAccounts.contains(opp.AccountId)){
                    opp.addError('You cannot create another Opportunity for this Account.'+
                                 ' within 24 hours of an existing Opportunity.');
                }  
            }
        }
    }
}