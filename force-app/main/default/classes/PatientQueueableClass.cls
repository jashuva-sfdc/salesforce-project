public class PatientQueueableClass implements Queueable,Database.allowsCallouts {

    private Set<Id> patientId;
    public PatientQueueableClass(Set<Id> patientId){
        this.patientId=patientId;
    }
    public void execute(QueueableContext qc) {
        System.debug('Queueable is Stated ');
        System.debug('Patient Id '+patientId);
        List<Patient__c> patientDetails =[SELECT Id,Name,Email_Address__c,Phone_Number__c,Age__c FROM Patient__c
                                          where Id IN:patientId];
        System.debug('Patient Data '+patientDetails);
        for(Patient__c p:patientDetails){
            String endpoint='callout:Google_Sheets/v4/spreadsheets/1p_QqPvZwk3oiI4pp3qNsFdl9GjJOuWB70FlQeU7kOk4'
          	 				 +	'/values/Patients!A:D:append'+'?valueInputOption=USER_ENTERED';
            
            Map<String,Object> payload=new Map<String,Object>{
                'values' => new List <Object>
                			{
                       		 new List<Object>{ 	  p.Name,
                                                  p.Email_Address__c,
                                                  p.Phone_Number__c,
                                                  p.Age__c
                            				}
                       		 }	
            };
              String body =JSON.serialize(payload);  
            HTTP protocol =new HTTP();
            //sending the request
            HttpRequest request =new HttpRequest();
            request.setEndPoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');
            request.setBody(body);
            
            HttpResponse response=protocol.send(request);
            
            String  respBody=response.getBody();
            System.debug('Response Body : '+JSON.deserializeUnTyped(respBody));
            System.debug('Google Status Code: '+response.getStatusCode());
        }
    }

}