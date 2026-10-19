public class QueueableHandlerEmailSendChain implements System.Queueable {

    private List<Account> accLst;
    public QueueableHandlerEmailSendChain(List<Account> lstAcc){
        this.accLst=lstAcc;
    }

    public void execute(QueueableContext qContext){
        String accDetails='';
        
        
        //Send the Email Notification for the updated all the records 
        Messaging.SingleEmailMessage sEmail=new Messaging.SingleEmailMessage();
        String[] toAddress=new String[]{'jashuva.sfdc@gmail.com'};
             sEmail.setToAddresses(toAddress);
             sEmail.setSenderDisplayName('ABHYRAM@ITSolutions');
           String subject ='Congratulations!!! Your Account Details has been update ';
        	 sEmail.setSubject(subject);
           String body='Its pleaseure to update your account details <br/>'+
               	       'Here are you details given below, please look at <br/>'+
                      'Account Name is :';
             sEmail.setHtmlBody(body);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{sEmail});
          
    }
}