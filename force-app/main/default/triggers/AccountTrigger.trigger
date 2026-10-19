trigger AccountTrigger on Account (after insert,after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        AccountHandler.updateContact(Trigger.new,Trigger.oldMap);
    }
}