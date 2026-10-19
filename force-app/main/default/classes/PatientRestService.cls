@RestResource(urlMapping='/patientCreation/*')
Global class PatientRestService {

    @HTTPPost
    global static string createPatient(String pName,Integer pAge,String pPhone){
       
         System.JSONGenerator js=JSON.createGenerator(true); //pretty printed formated content
        js.writeStartObject();
        try{
          Patient__c p =new Patient__c();
        	p.Name=pName;
        	p.Age__c =pAge;
        	p.Phone_Number__c=pPhone;
       	   insert p;
            js.writeStringField('Status','Success');
            js.writeStringField('Patient Id',p.Id);
        }catch(Exception e){
            js.writeStringField('Status','Failed');
            js.writeStringField('Error Message',e.getMessage());
        }
        js.writeEndObject();
        String result =js.getAsString();  
        return result;
		
    }
    
}