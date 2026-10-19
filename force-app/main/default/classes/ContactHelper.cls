public class ContactHelper {
    public static void preventContactDeletion(List<Contact> lstCon){
        for(Contact con:lstCon){
            if(con.Primary_Contact__c ==true){
                con.addError('Deleting The Contact Is not Allowed,BCZ This Contact is Primary Contact');
            }
        }
    }
    
    public static void countContactOnCreation(List<Contact> lstCon){
        if(lstCon !=null){
            //Get The Related AccountId 
            Set<Id> accRelId =new Set<Id>();
            for(Contact con:lstCon){
                if(con.AccountId !=null){
                    accRelId.add(con.AccountId);
                }
            }
            //Count the Contacts the which are associated with Account and Add the count && AccountId into Map
            Map<Id,Integer> countContMap=new Map<Id,Integer>();
            for(AggregateResult ar:[SELECT AccountId accountRelId, COUNT(Id) totalConCount FROM Contact
                                   WHERE AccountId IN :accRelId GROUP BY AccountId]){
                countContMap.put((Id)ar.get('accountRelId'),(Integer)ar.get('totalConCount'));
            }
          //update inside the Account 
         //Here we have 2 Approaches directly I can iterate set accRelId or I can get the Accounts
         List<Account> updateAcc=[SELECT Id,Contact_Count__c FROM Account Where Id IN:accRelId]; 
            for(Account acc:updateAcc){
               acc.Contact_Count__c =countContMap.containsKey(acc.Id)?countContMap.get(acc.Id):0;
            }
            if(!updateAcc.isEmpty()){
                update updateAcc;
            }
          /*Another Approach Is better when you know only update on particular fields 
          List<Account> accToUpdate =new List<Account>();
            for(Id accId:countContMap.keySet()) //keySet will return all the Keys in the Map --i.e ->Id's
            {
               Account acc =new Account(Id=accId,Contact_Count__c=countContMap.get(accId)); 
                accToUpdate.add(acc);
            }
            if(!accToUpdate.isEmpty()){
                update accToUpdate;
            }
			**/
        }  
    }
    
    //Automatically Creating an Opportunity for Non-Primary Contacts Upon Inserting AND Updating
    public static void createOpportunity(List<Contact>newLst,Map<Id,Contact>oldMap){
        if(newLst !=null)
        {
            List<Opportunity> lstOpp =new List<Opportunity>();
                for(Contact con:newLst){
                    if(oldMap ==null){
                        if(con.Primary_Contact__c ==false) //!con.Primary_Contact__c we can check like this 
                        {
                       //On Insertion Creating The Data
                       Opportunity opp =new Opportunity();
                        opp.Name='Testing Record';
                        opp.StageName='Prospecting';
                        opp.CloseDate=System.today();
                        opp.AccountId=con.AccountId;
                        lstOpp.add(opp);
                        }

                    }else {
                        //On Updation Creating The Data 
                        Contact oldData=oldMap.get(con.Id);
                        if(!con.Primary_Contact__c && con.Primary_Contact__c !=oldData.Primary_Contact__c){
                           Opportunity opp =new Opportunity();
                            opp.Name='Testing Record';
                            opp.StageName='Prospecting';
                            opp.CloseDate=System.today();
                        	opp.AccountId=con.AccountId;
                        lstOpp.add(opp); 
                        }
                    }          
                }
            if(!lstOpp.isEmpty()){
                   Insert lstOpp; 
              } 
        }
      }
}