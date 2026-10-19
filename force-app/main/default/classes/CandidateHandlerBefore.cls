public class CandidateHandlerBefore {
    
    public static void duplicationCheck(List<Candidate__c> lstCand){
        Set<String> emailCheck=new Set<String>();
        Set<String> phoneCheck=new Set<String>();
        
        //collect the phone and email coming from new records and store it inside the collection 
        for(Candidate__c c:lstCand){
            if(c.Phone_Number__c !=null){
                phoneCheck.add(c.Phone_Number__c);
            }
            if(c.Email_Address__c !=null){
                emailCheck.add(c.Email_Address__c);
            }
        }
        
        //Get the Email and PHONE from the Database
        List<Candidate__c> candData =[SELECT Id, Email_Address__c, Phone_Number__c FROM Candidate__c 
                                      Where Email_Address__c=:emailCheck AND Phone_Number__c=:phoneCheck];
        //add the email into set collection
        Set<String> existingEmail=new Set<String>();
        Set<String> existingPhone=new Set<String>();
        for(Candidate__c cnd:candData){
            if(cnd.Email_Address__c !=null){
               existingEmail.add(cnd.Email_Address__c); 
            }
            if(cnd.Phone_Number__c !=Null){
                existingPhone.add(cnd.Phone_Number__c);
            }
        }
        //validate the object 
        for(Candidate__c cd:lstCand){
            if(cd.Email_Address__c !=null && cd.Phone_Number__c !=null){
                if(existingEmail.contains(cd.Email_Address__c) && existingPhone.contains(cd.Phone_Number__c)){
                    cd.addError('Duplicate Records are not Allowed Having the Same Email OR Phone');
                }
            }
        }
    }
    
    public static void fillDetailsBefore(List<Candidate__c> lstCand){
      
        for(Candidate__c c:lstCand){
            if(c.Phone_Number__c >='10'){
                c.Phone_Number__c.addError('Phone Number Must Be In 10 Digits.');
            }
            if(c.Name !=null){
                String firstName=c.Name;
                firstName=firstName.substring(0,1).toUpperCase();
                firstName=firstName.substring(1);
                c.Name=firstName;
                /*OR Dirctly we can use string function
                 * c.Name=c.Name.substring(0,1).toUpperCase()+c.Name.substring(1);
				*/
              }
            //If Email is not in the format e.g gmail.com OR outlook.com then don't allow the record saving
           Integer index=c.Email_Address__c.indexOf('@');
            if(index !=-1){
              String domain= c.Email_Address__c.substring(index+1);
                if(domain !='gmail.com' || domain !='outlook.com'){
                    c.Email_Address__c.addError('Only Gmail and Outlook email addresses are allowed.');
                }
            }
        }   
    }
}