public class PatientBatchClass implements Database.Batchable<SObject> {

    // Step 1: Fetch records
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, Patient_Status__c FROM Patient__c]);
    }

    // Step 2: Process records in batches
    public void execute(Database.BatchableContext bc, List<Patient__c> scope) {
        for (Patient__c patient : scope) {
            patient.Patient_Status__c = 'Active';
        }
        update scope;
        System.debug('Batch processed: ' + scope.size() + ' records');
    }
    // Step 3: Runs after all batches finish
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Apex Completed Successfully');

    }

}