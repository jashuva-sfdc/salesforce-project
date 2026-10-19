@isTest
public class PatientSearchUtilityTest {

    @isTest
    public static void testPatientSearch(){
        Patient__c p =new Patient__c();
        p.Name='Testing Record';
        p.Age__c=25;
        p.Phone_Number__c='9876543210';
        insert p;
        Test.startTest();
        PatientSearchUtility.getAllPatients();
        PatientSearchUtility.getAdultPatients();
        PatientSearchUtility.searchPatient();
        Test.stopTest();
    }
}