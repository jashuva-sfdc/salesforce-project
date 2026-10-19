public class GoogleSheetsConnection {

    public static void expandGoogleSheet(){
        HTTP protocol =new HTTP();
        
        HttpRequest request =new HttpRequest();
        
        String endPoint='callout:Google_Sheets/v4/spreadsheets/1p_QqPvZwk3oiI4pp3qNsFdl9GjJOuWB70FlQeU7kOk4'
            +'/values/Patients!A:D:append'+'?valueInputOption=USER_ENTERED';
        request.setEndPoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        
        String body = '{' +
            		'"values": [[' +
                                    '"Bangaru Raju",' +
                                    '"raju@gmail.com",' +
                                    '"9876543210",' +
                                    '26' +
            					']]' +
       				 '}';
        request.setBody(body);
        //store the response 
		HttpResponse response=protocol.send(request);
        
        System.debug('Get The Status Code: '+response.getStatusCode());
        System.debug('Get Resoponse Body : '+response.getBody());
    }
}