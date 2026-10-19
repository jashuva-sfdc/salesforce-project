trigger AppointmentTrigger on Appointment__c (before insert,before update,after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            AppointmentHandler.uniqueAppointmentDate(Trigger.new);
        }
        
    }
    if(Trigger.isAfter){
       if(Trigger.isUpdate){
            AppointmentHandler.createBilling(Trigger.new, Trigger.oldMap);
        } 
    }
}