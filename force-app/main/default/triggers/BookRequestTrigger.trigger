trigger BookRequestTrigger on Book_Request__c (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            BookRequestHandler.shareRecordsToBookOwner(Trigger.new);
        }
    }
}