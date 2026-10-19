public class IntegrationTextLocal {
   
    public static void sendSMS(Set<Id>leadIds){
        List<Lead> leads=[SELECT Id,LastName,Phone FROM Lead Where Id IN: leadIds];
        for(Lead ld:leads){
          String endPoint ='https://api.webexinteract.com/v1/sms';
          String apiKey='aky_3GswYXy42toOlIeAzkMuchmMYTs';
          String fromComp='';
          String messageBody ='';
          
            HTTP protocol =new HTTP();
            HTTPRequest request =new HTTPRequest();
            request.setEndpoint(endPoint);
            request.setMethod('POST'); 
            request.setHeader('Authentication',apiKey);
        }
         
        
    }
}