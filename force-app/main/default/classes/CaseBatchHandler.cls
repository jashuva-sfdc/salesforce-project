public class CaseBatchHandler implements Database.Batchable<sObject>
{
    private Set<Id> caseId;
    public CaseBatchHandler(Set<Id> caseId){
        this.caseId=caseId;
    }
    public Database.queryLocator start(Database.BatchableContext bContext){
        System.debug('==========START MEthod Started==============');
        return Database.getQueryLocator([SELECT Id,CaseNumber,Status,OwnerId FROM Case 
                                         Where Id IN: caseId AND  
                                         Status !='Closed']);
    }
    public void execute(Database.BatchableContext bContext,List<Case>scope){
        List<Messaging.SingleEmailMessage> lstEmail =new List<Messaging.SingleEmailMessage>();
        System.debug('Batch Started ================================>');
        System.debug('Scope Size '+scope.size());
        System.debug('Cases are : '+scope);
        Set<Id> caseOwnerId =new Set<Id>();
        for(Case cs:scope){
            if(cs.Status !='Closed'){
                caseOwnerId.add(cs.OwnerId);
            }
        }
        System.debug('Case Owner Id '+caseOwnerId);
        //Get the User Details To Send An Email to Case Owner
        List<User> userEmail =[SELECT Id,Email FROM User Where Id IN: caseOwnerId AND Email !=NULl];
        
        //Add User Id with Email in Map,Bcz u have to send the Owner Email Directly u r not able to get it so we need to use Map
        Map<Id,String> userEmailMap =new Map<Id,String>();
        for(User user:userEmail){
            userEmailMap.put(user.Id,user.Email); 
        }
        System.debug('Email Map : '+userEmailMap);
        //Send email to user 
        for(Case cs:scope){
            if(cs.Status !='Closed'){
                String userMail=userEmailMap.get(cs.OwnerId);
                Messaging.SingleEmailMessage sEmail =new Messaging.SingleEmailMessage();
                String [] toAddress=new String[]{userMail};
                sEmail.setToAddresses(toAddress);
                // String [] bccAddress =new String[]{};
                sEmail.setBccAddresses(new List<String>{'jashuva.sfdc@gmail.com'});
                String subject ='Case is in Open Please Follow up, Case Number is : '+cs.CaseNumber;
                sEmail.setSubject(subject); 
                String body ='Dear User Please Follow Up the Case '+
                    	'<br/>'+'Thanks and Regards'+
                    	'<br/>'+'support@salesforce.com';
                sEmail.setHtmlBody(body);
                
                lstEmail.add(sEmail);
            }    
        }
        if(!lstEmail.isEmpty()){
            Messaging.SendEmailResult[] result=Messaging.sendEmail(lstEmail);
            for(Messaging.SendEmailResult res:result){
                System.debug('Email Success : '+res.isSuccess());
                if(!res.isSuccess()){
                    System.debug('Error Message : '+res.getErrors());
                }
            }
            System.debug('Email list size = ' + lstEmail.size());
            System.debug('Email invocations = ' + Limits.getEmailInvocations());
            System.debug('Email invocation limit = ' + Limits.getLimitEmailInvocations());
        }
    }
    public void finish(Database.BatchableContext bContext){
      //If u have to send the email in finish just write the entire execute method logic here
      //and fetch cases using case id  
    }
}