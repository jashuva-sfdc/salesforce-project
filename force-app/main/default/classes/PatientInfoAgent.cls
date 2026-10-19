public with sharing class PatientInfoAgent{
    
    @InvocableMethod(label='Patient Agent'
                     description='This Agent is Used to Provide the Patient Details On UI Based on the Patient Name')
    public static List<String> getPatientDetails(List<String> requestName){
        List<String> result =new List<String>();
        if(requestName !=null){
        //store the patient names in set bcz to query the all the patient details if u need sigle field no need to use set
        Set<String> patientName=new Set<String>();
        for(String str:requestName){
            if(str !=null){
               patientName.add(str); 
            }
        }
            
        //Query the Patient Details Based On Patient Name
        List<Patient__c> patientDetails=[SELECT Id,Name,Email_Address__c,Phone_Number__c,Age__c FROM Patient__c 
                                         where Name IN:patientName];
            if(patientDetails.isEmpty()){
                result.add('Patient Name was Not Found Please Enter a Valid Name');
                return result;
            }
        
            for(Patient__c p:patientDetails){
                String patientInfo= 'Patient Name  : '+p.Name +
                    				' Patient Age   : '+p.Age__c+
									' Patient Email : '+p.Email_Address__c+
                    				' Phone Number : '+p.Phone_Number__c ;
                result.add(patientInfo);
            }    
           
      }
        return result;
    }
    
}