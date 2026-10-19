trigger BookTrigger on Book__c (before insert) {
    if(Trigger.isBefore){
        BookHandler.preventDuplicate(Trigger.new);
    }
}