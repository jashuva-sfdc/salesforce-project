public class AsyncOperationsHandler {
    @future
    public static void createUserContact(String nick){
        
        User userInfo=[SELECT Id,FirstName,LastName,UserName,Email,Alias,IsActive FROM User
                       Where UserName =: nick
                       LIMIT 1];
        userInfo.IsActive=false;  
        update userInfo;
        //Create a New Contact Record giving the same details of User
        Contact con =new Contact();
        con.FirstName=userInfo.FirstName;
        con.LastName=userInfo.LastName;
        con.Email=userInfo.Email;
        
        Insert con;
    }
    /*When  Opportunities are closed won at once, recalculate a score on all related Contacts asynchronously.
     *  Prove it works in bulk without hitting limits.
     * To perform this first of all we have to get the releated Account,bcz of Account is 
     *  Account
     *   |----Contact
     *   |
     *    ----Opportunity
     * */
    public static void updateContactScore(List<Opportunity> lstOpp){
        
        //get the AccountId for opportunities where the stage is closed won 
        Set<Id> accIdRelOpp=new Set<Id>();
        for(Opportunity opp:lstOpp){
            if(opp.AccountId !=null && opp.StageName =='Closed Won'){
                accIdRelOpp.add(opp.AccountId);
            }
        }
        //Get the Account Having the Contact
        List<Contact> conScoreUpdate=[SELECT AccountId,Score__c From Contact Where AccountId IN: accIdRelOpp];
        //and then for same Account having the contacts update score 
        for(Contact con:conScoreUpdate){
            if(con.AccountId !=null){
                if(con.Score__c ==null){  
                    con.Score__c = 10;
                }else{
                    con.Score__c= con.Score__c +10;
                }
            }
        }
        if(!conScoreUpdate.isEmpty()){
           update conScoreUpdate;   
        }
    }
}