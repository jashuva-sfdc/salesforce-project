public class IntegrationOrgB {

    public static void testConnection(){
        //Getting the end point url from named credentials 
        String endPoint='callout:Org_B_Case_Search_API/services/data/';
        HTTP protocol =new HTTP();
        HttpRequest request =new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod('GET');
        
        try{
         HttpResponse response =protocol.send(request);
            JSON.serialize(response.getBody());
         System.debug('Status Code is : '+response.getStatusCode());
         System.debug('Response Body : '+response.getBody());
        }catch(Exception e){
            System.debug('CallOut Error : '+e.getMessage());
        }        
        
    }
}