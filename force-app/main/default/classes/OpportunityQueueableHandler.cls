public class OpportunityQueueableHandler implements Queueable{
    
    private List<Lead> leadClosed;
    public OpportunityQueueableHandler(List<Lead>lstLead){
        this.leadClosed =lstLead;
    }
    public void execute(QueueableContext qContext){
        //create the Opportunity record
        List<Opportunity> lstOpp =new List<Opportunity>();
        for(Lead ld:leadClosed){
            Opportunity opp =new Opportunity();
            opp.AccountId=ld.Name;
        }
    }
}