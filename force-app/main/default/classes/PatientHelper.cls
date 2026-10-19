public class PatientHelper {
	public static void updatePatientStatus(List<Patient__c> newPatients)
    {
        for(Patient__c patient : newPatients)
        {
            if(patient.Age__c != null && patient.Age__c < 0)
            {
                patient.Age__c.addError('Age cannot be less than 0.');
            }
        }
    }
    public static void validateAge(List<Patient__c> newPatients)
    {
        for(Patient__c patient : newPatients)
        {
            if(String.isBlank(patient.Phone_Number__c))
            {
                patient.Phone_Number__c.addError('Phone number should not be blank.');
            }
        }
    }
    
    public static void sendPatientData(List<Patient__c> newPatients)
    {
        for(Patient__c patient : newPatients)
        {
            System.Debug('Patient created successfully. Patient Id: ' + patient.Name);
        }
    }
    
}