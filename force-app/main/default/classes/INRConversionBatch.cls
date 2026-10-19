public class INRConversionBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bContext){
        
        return Database.getQueryLocator([SELECT Id,Amount FROM Opportunity where Amount !=null]);
    }
    public void execute(Database.BatchableContext bContext, List<Opportunity> scope){
        //logic
        String endPoint ='http://api.currencylayer.com/live?access_key=d2f02243a3816eab5d5b24321c360b12&source=USD&currencies=INR&format=1';
        HTTP protocol =new HTTP();
        HTTPRequest request =new HTTPRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        
        //Collecting the response from 
        HTTPResponse response =protocol.send(request);
        String result=response.getBody();
        
        //DESERIALIZE THE DATA
        System.JSONParser parser =JSON.CreateParser(result);
        Decimal amnt;
        while(parser.nextToken()!=null){
            if(parser.getText() =='USDINR')//source
            {
                 parser.nextToken();
                amnt =parser.getDecimalValue();
               
            }
        }
        System.debug('CURRENT PRICE INR :'+amnt);
        //update the Converted amount in Opportunity 
        for(Opportunity opp:scope){
           opp.INR_Value__c ='Rs.'+ (amnt * opp.Amount); 
        }
        update scope;
    }
    public void finish(Database.BatchableContext bContext){
        //sent an email to the customer 
        
    }
}