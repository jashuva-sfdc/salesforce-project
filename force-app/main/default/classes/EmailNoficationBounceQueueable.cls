public class EmailNoficationBounceQueueable implements Queueable {
    private Set<Id> emailIds;
    public EmailNoficationBounceQueueable(Set<Id> emailMessageId){
        this.emailIds =emailMessageId;
    }
    
    public void execute(QueueableContext qContext){
        try{
            //Query The Email Records To Iterate that List and Collect the Releated Case Id's
        List<EmailMessage> lstEmail=[SELECT Id,ParentId,MessageDate From EmailMessage where Id IN:emailIds];
      
        //Collect the Case ID's which are related to Emails
        Set<Id> caseId =new Set<Id>();
        for(EmailMessage  em:lstEmail){
		  //Adding Case Releated Only Bounced Emails Id's
            if(em.ParentId !=null){
                caseId.add(em.ParentId);
            }
        }
        if(caseId.isEmpty()){
            return;
        }
        //Collect this Case records which are having the emails
        Map<Id,Case> mapCase =new Map<Id,Case>([SELECT Id,CaseNumber,Subject,OwnerId FROM Case Where Id IN: caseId]);
        System.debug('Case Details '+mapCase);
        //Collect the OwnerId from the Case
        Set<Id> ownerId =new Set<Id>();
        for(Case cs:mapCase.values()){
            if(cs.OwnerId !=null){
                ownerId.add(cs.OwnerId);
            }
        }
        //Get The Owner Email Details To Send An Email Regardings to the Bounce Mail
        Map<Id,User> mapUser =new Map<Id,User>([SELECT Id,Email FROM User where Id IN: ownerId]);
        System.debug('Map Users '+mapUser);
        // Base URL to build the Case record link
         String baseUrl =URL.getOrgDomainUrl().toExternalForm();
        
        //Send an Email to Case Owner 
        List<Messaging.SingleEmailMessage> lstMessage =new List<Messaging.SingleEmailMessage>();
        for(Case cs:mapCase.values()){
             //Skip if the case is not containg the any owner i.e either it is containing the Queue like that
            if(!mapUser.containsKey(cs.OwnerId)){
                continue;
            }
            //Get The User 
             User userDetails=mapUser.get(cs.OwnerId);
            
            String caseLink =baseUrl+'/'+cs.Id;
            
            Messaging.SingleEmailMessage msg=new Messaging.SingleEmailMessage();
            msg.setToAddresses(new List<String>{userDetails.Email});
            msg.setCcAddresses(new String[]{'swarnajashuva@gmail.com'});
            msg.setSubject('Email Bounced for Case : '+cs.CaseNumber);
            String body='Hello '+'The email sent to the customer for Case '+cs.CaseNumber +
                        '<br/>'+' has bounced '+ 'Case Link '+caseLink
                       +'<br/>'+'Regards Support Team';
            msg.setHtmlBody(body);
            msg.setSaveAsActivity(false);
            lstMessage.add(msg);
            
        }
            
            if(!lstMessage.isEmpty()){
                Messaging.sendEmail(lstMessage);
            }
            
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, 'EmailNoficationBounceQueueable failed: ' + e.getMessage() + ' | ' + e.getStackTraceString());

        }
    }
    
}