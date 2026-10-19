trigger ContactTrigger on Contact (before insert,before update,before delete,after insert,after update,after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert  || Trigger.isUpdate){
            ContactHandler.preventContact(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isDelete){
            ContactHelper.preventContactDeletion(Trigger.old);
            ContactHandler.preventContactDeletion(Trigger.old);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContactHelper.countContactOnCreation(Trigger.new);
            ContactHelper.createOpportunity(Trigger.new,null); 
        }
        if(Trigger.isUpdate){
            ContactHelper.createOpportunity(Trigger.new,Trigger.oldMap); 
        }
        if(Trigger.isDelete){
            ContactHelper.countContactOnCreation(Trigger.old);
        }
    } 
   
}