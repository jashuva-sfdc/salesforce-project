public class SOQLQueries {

    //Fetch the Accounts having more than 5 opp with stage name is closed won and amount is more than 25000
    public static void AccountQuery(){
     
        //Directly we can not write the Aggregate queries in sub queries here we have to use apex
        List<AggregateResult> result=[SELECT AccountId acc, Count(Id) oppCount FROM Opportunity WHERE StageName ='Closed Won'
                                   AND Amount >=25000
                                   GROUP By AccountId
                                   Having Count(Id)>=2];
        //collect the account id with that AccountId we will fetch the data from Account
        Set<Id> accOppRelId=new Set<Id>();
        for(AggregateResult ar:result){
            accOppRelId.add((Id)ar.get('acc'));     
        }
        List<Account> accWithOpp=[SELECT Id,Name FROM Account WHERE Id IN :accOppRelId];
        System.debug('Accounts are having the more than 2 Opportunities with Closed Won And Amount : '+accWithOpp);
    }
}