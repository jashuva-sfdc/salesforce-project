trigger ServiceRequestTrigger on Service_Request__c (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ServiceRequestHandler.validateOwnerLimit(Trigger.new, NULL);
        }
        if(Trigger.isUpdate){
            ServiceRequestHandler.validateOwnerLimit(Trigger.new, Trigger.oldMap);
        }
    }
}