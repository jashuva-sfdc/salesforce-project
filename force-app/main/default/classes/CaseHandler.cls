public class CaseHandler
{
    //This code will counts the data based on Insertion and Deletion
    public static void insertCount(List<Case> lstCase){
        if(lstCase !=null){
            
            Set<Id> accRelId =new Set<Id>();
            for(Case cs:lstCase){
                if(cs.AccountId !=null){
                    accRelId.add(cs.AccountId);
                }
            }
            
            countOfCaseOrigin(accRelId);
        }
    }
    //This is For Updation like whenever a Case is Updated 
    public static void updateCount(List<Case> lstCase, Map<Id,Case> mapCase){
        if(lstCase !=null){
              Set<Id> accRelId =new Set<Id>();
                for(Case newCase:lstCase){
                    if(newCase.AccountId !=null)
                    {
                        Case oldCase=mapCase.get(newCase.Id);
                        if(newCase.Origin != oldCase.Origin)
                        {
                             accRelId.add(newCase.AccountId);
                        }
                    }
                }
            countOfCaseOrigin(accRelId);
      }
    }
    //counting the case records based on origin
    public static void countOfCaseOrigin(Set<Id> accRelId){
             Map<Id,Integer> phoneMap =new Map<Id,Integer>();
             Map<Id,Integer> webMap =new Map<Id,Integer>();
             Map<Id,Integer> emailMap =new Map<Id,Integer>();
            
            for(AggregateResult ar:[SELECT AccountId  accountId, Origin originValues,Count(Id) totalCaseCount from Case 
                                    where AccountId IN:accRelId
                                    Group by AccountId, Origin])
            {
                //Performing the TYPE casting Getting the ID
               Id accountId =(Id)ar.get('accountId');
                //Getting the ORIGIN VALUES
               String originData=(String)ar.get('originValues'); 
                //Getting the count of Cases
               Integer countValue=(Integer)ar.get('totalCaseCount'); 
			   if(originData =='Phone')
			    {
                   phoneMap.put(accountId,countValue); 
                }
                if(originData =='Email')
                {
                    emailMap.put(accountId,countValue);
                }
                if(originData =='Web')
                {
                    webMap.put(accountId,countValue);
                }
                                        
            }
            List<Account> accountUpdate =[SELECT Id,Count_Phone__c,Count_Email__c,Count_Web__c FROM Account
                                         WHERE Id IN :accRelId];
            for(Account acc:accountUpdate){
               acc.Count_Phone__c=phoneMap.containsKey(acc.Id)? phoneMap.get(acc.Id):0;
                 acc.Count_Email__c=emailMap.containsKey(acc.Id)? emailMap.get(acc.Id):0;
               acc.Count_Web__c=webMap.containsKey(acc.Id)? webMap.get(acc.Id):0; 
            }
            if(!accountUpdate.isEmpty()){
                update accountUpdate; 
            }
    }
    
    //Assinging the records to Queues based on Origin
    public static void assginCasesToQueues(List<Case>lstCase){
      
        if(lstCase !=null){     
            //Fetch The Queue  Members
            Map<Id,String> queueMem=new Map<Id,String>();
            for(Group g:[Select Id,Name,Type From Group
                        Where Type ='Queue' AND Name IN('Phone_Origin_Queue','WEB_Origin_Queue')]){
                queueMem.put(g.Id,g.Name);
            }
            for(Case cs:lstCase){
                if(cs.Origin =='Web'){
                    cs.OwnerId=queueMem.get('Phone_Origin_Queue');
                }else if(cs.Origin =='Phone'){
                    cs.OwnerId=queueMem.get('WEB_Origin_Queue');
                }
            }
        }
    }
    //IF Case is Closed then send the Emails  Except ths "librarylibrarian9493@gmail.com" Case Owner
    public static void sendEmailToUser(List<Case> lstCases,Map<Id,Case>mapCases){
        if(lstCases !=null){
         Set<Id> contactRelId =new Set<Id>();
            for(Case cs:lstCases){
                Case oldCase=mapCases.get(cs.Id);
                if(cs.ContactId !=null && cs.Id !=oldCase.Id){
                    contactRelId.add(cs.ContactId);
                }  
            } 
           //Get the Email from Contact 
           Map<Id,Contact> mapCont=new Map<Id,Contact>([SELECT Id,Email FROM Contact where Id IN:contactRelId AND Email !=null]); 
            
            //Fetching the User Id from Custom Meta data
            Librarian_User__mdt mdt =[SELECT Librarian_User__c FROM Librarian_User__mdt 
                                      WHERE DeveloperName ='Data_Migration_User_Id' LIMIT 1 ];
            
         List<Messaging.SingleEmailMessage> lstEmail =new List<Messaging.SingleEmailMessage>();
            for(Case newCases:lstCases){
             Case oldCases=mapCases.get(newCases.Id);
                Contact con=mapCont.get(newCases.ContactId);
                if(newCases.Status =='Closed' && oldCases.Status !=newCases.Status && newCases.CreatedById !=mdt.Librarian_User__c){
                   Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                    String[] toAddress =new String[]{con.Email};
                        email.setToAddresses(toAddress);
                    String [] bccAddress=new String[]{'jashuvaswarna.sfdc@gmial.com','swarnajashuva@gmail.com'};
                        email.setBccAddresses(bccAddress);
                    String subject ='Case Closed  - Case '+newCases.CaseNumber;
                    email.setSubject(subject);
                    String body ='Hello '+con.Name+
                        		 'Your Support Case:'+newCases.CaseNumber+' has been Closed '+
                        		 '<br/>'+'Case Subject     :'+newCases.Subject +
                        		 '<br/>'+'Case Description :'+newCases.Description +
                        		 '<br/>'+'Case Number	   :'+newCases.CaseNumber +
                        		 '<br/>'+'If you have any further questions or need additional assistance,'+
                        		 '<br/>'+'Please Contact Our Support Team '+
                        		 '<br/>'+'Thank You'+
                        			'Support Team';
                    email.setPlainTextBody(body);
                    email.setSenderDisplayName('ABHIT Team');
                    
                    lstEmail.add(email);
                }
            }
            if(!lstEmail.isEmpty()){
                Messaging.sendEmail(lstEmail);
            }
        }  
    }
}