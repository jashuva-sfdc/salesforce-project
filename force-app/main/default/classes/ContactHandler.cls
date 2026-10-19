public class ContactHandler {

    public static void updateNamesInAccount(List<Contact> newList,Map<Id,Contact> oldMap){
        //Fetch the Account Related Id 
        Set<Id> accRelId=new Set<Id>();
        for(Contact con:newList){
            if(con.AccountId !=null){
                if(oldMap ==null){
                     accRelId.add(con.AccountId);
                }else{
                      Contact oldId=oldMap.get(con.Id); 
                     if(con.Name !=oldId.Name){
                  	 accRelId.add(con.AccountId);
                    }
                }
            }
        }
        
        //Fetch the contact details with releated to Account
        List<Contact> conDetails =[SELECT AccountId,Name From Contact
                                  where AccountId IN :accRelId];
        
        //Account ---> Contact Names adding into the Map ,One Account Contains Group of Contacts
        Map<Id,List<String>> contNames =new Map<Id,List<String>>();
        for(Contact con:conDetails){
            if(!contNames.containsKey(con.AccountId)){
                //first addingthe ID Into Map next with empty string
                contNames.put(con.AccountId,new List<String>());
            } 
            //for that Id adding the Name into the List
            contNames.get(con.AccountId).add(con.Name);
        }
        List<Account> accToUpdate=new List<Account>();
        //Fetching the Names and adding inside the Account with ;;
        for(Id namesId:contNames.keySet()){
            //here we cannot directly assign to list that is the reason we are using
            //String.join() it will converts the names into List
            // new List<String>{'Jash','AJay'},';' like this 
            Account acc=new Account(Id =namesId,
                         			Contact_Names__c=String.join(contNames.get(namesId),';')
                                   );
           accToUpdate.add(acc);
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
 
    
    //when ever a contact is created with an account update the Account Description as Contact Email
    //AND Contact Description with Account Email
  public static void updateAccDes(List<Contact> newCon){
      if(newCon !=null){
          Set<Id> accRelId =new Set<Id>();
         List<Sobject> allObjects = new List<Sobject>();
        for(Contact con:newCon){
            if(con.AccountId !=null && con.Email !=null){
                accRelId.add(con.AccountId);
            }
        } 
      
      
        
        //Get The Accounts Which Are Having the Contact and Update the Acc Description as Contact Email
        Map<Id,Account> mapAcc=new Map<Id,Account>([SELECT Id,Name,Description From Account WHERE Id IN:accRelId]);
        
        //If you want update the contact records after insert u have to create the contact object add data into that then update
       // List<Contact> conToUpdate =new List<Contact>();
        
      
        for(Contact con :newCon){
            if(mapAcc.containsKey(con.AccountId)){
                //updating the Account Description with con Email 
                Account accDetails=mapAcc.get(con.AccountId);
                accDetails.Description=con.Email;
                
                //Update the Contact Description With Acc Name
                Contact cont =new Contact(Id=con.Id,Description =accDetails.Name);
                allObjects.add(cont);
                allObjects.add(accDetails);
            } 
        }
        if( !allObjects.isEmpty()){
            update allObjects;
        }
    }
  }
    //prevent the contact deletion if the contact is having any open cases
    public static void preventContactDeletion(List<Contact> lstContact){
        Set<Id> contactId =new Set<Id>();
        for(Contact con:lstContact){
            contactId.add(con.Id);
        }
        //Fetch the Open Cases which are associated with Contact
        List<Case> lstCases=[SELECT CaseNumber,ContactId FROM Case WHERE ContactId IN:contactId
                            AND IsClosed =false];
        
        //add contact id's into set 
        Set<Id> contactWithCaseId =new Set<Id>();
        for(Case cs:lstCases){
            if(cs.ContactId !=null){
                contactWithCaseId.add(cs.ContactId);
            }
        }
        for(Contact con:lstContact){
            if(contactWithCaseId.contains(con.Id)){
                con.addError('Contact is having Open Cases cDeletion is not Possible');
            }   
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactDetails(){
       List<Contact> contactWithAcc=[SELECT FirstName,LastName,Phone, Account.Name FROM Contact Where AccountId !=NULL LIMIT 10];
        return contactWithAcc;
    }
    
    //if contact is having any existing Accounts, then choosing same account don't allow it.
    public static void preventContact(List<Contact> lstCont,Map<Id,Contact> mapCont){
        if(lstCont !=null){
            Set<Id> accRelId =new Set<Id>();
            for(Contact cont:lstCont){
                if(mapCont ==null){
                    if(cont.AccountId !=null){
                        accRelId.add(cont.AccountId);
                    }
                } else{
                    Contact oldData=mapCont.get(cont.Id); 
                    if(oldData !=null){
                        if(oldData.AccountId !=cont.AccountId){
                            accRelId.add(oldData.AccountId);
                        }
                    }
                }   
            }
            //Fetch the existing Contacts with same account
            List<Contact> existingContacts =[SELECT AccountId FROM Contact Where AccountId IN:accRelId];
            
            Set<Id> uniqueIds=new Set<Id>();
            for(Contact cont:existingContacts){
                uniqueIds.add(cont.AccountId);
            }
            for(Contact con:lstCont){
                if(uniqueIds.contains(con.AccountId)){
                 con.addError('Duplicate Accounts Not Allowed');   
                }
            }
        } 
    }
}