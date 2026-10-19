public class IntegrationUTrace 
{
    public String ipAddress {set;get;}
    public String status {set;get;}//Either any data send successfully or not 
    public String body {set;get;}
    public String data {set;get;}
    
    public  void callUTraceDetails(){
        
        //Stroe the Endpoint
       String endpoint='https://en.utrace.me/';
        //Create HTTP Protocol Structure
        HTTP protocol =new HTTP();
        //Create The Request
        HTTPRequest request=new HTTPRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        //Strore the Response after sending the reqeust
        HttpResponse response =protocol.send(request);
        body=response.getBody();
        
        //After fetching the data convert into the normal format
        
    }
}