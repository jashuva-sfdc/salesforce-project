public class PatientSearchUtility {
    // Method 1: Get all patients
    public static void getAllPatients() {
        List<Patient__c> patients = [SELECT Id, Name, Age__c FROM Patient__c];
        System.debug('All Patients: ' + patients);
    }

    // Method 2: Get adult patients
    public static void getAdultPatients() {
        List<Patient__c> adultPatients = [ SELECT Id, Name FROM Patient__c WHERE Age__c >= 18 ];
        System.debug('Adult Patients: ' + adultPatients);
    }
    // Method 3: Search using SOSL
    public static void searchPatient() {
        List<List<SObject>> searchResults = [ FIND 'Ravi'IN ALL FIELDS RETURNING
                                             Patient__c(Name), Doctor__c(Name)];
        System.debug('Search Results: ' + searchResults);
    }
}