trigger PatientTrigger on Patient__c (before insert, after insert, before update, after update) {
	if(Trigger.isBefore)
    {
        if(Trigger.isInsert){
            PatientHelper.updatePatientStatus(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            PatientHelper.updatePatientStatus(Trigger.new);
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert){
            PatientHelper.sendPatientData(Trigger.new);
            Set<Id> patientIds=new Set<Id>();
            for(Patient__c p:Trigger.new){
                if(p.Id !=null){
                    patientIds.add(p.Id);
                }
            }
            System.enqueueJob(new PatientQueueableClass(patientIds));
        }
    }
}