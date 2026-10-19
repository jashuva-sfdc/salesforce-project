public class QueueableHandler implements Queueable {
    
  
    public void execute(System.QueueableContext qContext){
      List<Account> lstAccount=[SELECT Id, Name,Phone, Rating,Industry,Type From Account 
                               Where Type='Other' LIMIT 3];
        
        for(Account acc:lstAccount){
            acc.Rating='Hot';
        }
        if(!lstAccount.isEmpty()){
            update lstAccount;
        }
        // To send email notification from another Queueable 
        System.enqueueJob(new QueueableHandlerEmailSendChain(lstAccount));
    }
}