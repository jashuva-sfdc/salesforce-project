public class BatchHandler implements Database.Batchable<sObject> {
 
    public Database.queryLocator start(Database.BatchableContext bContext){
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    public void execute(Database.BatchableContext bContext,List<Account> lstSobj){
        for(Account acc:lstSobj){
            //
        }
    }
    public void finish(Database.BatchableContext bContext){
        //call the finish method 
        AsyncOperationsHandler.createUserContact('jashuva.sfdc@2002gmail.com');
    }
}