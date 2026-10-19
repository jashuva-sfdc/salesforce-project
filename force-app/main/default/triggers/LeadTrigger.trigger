trigger LeadTrigger on Lead (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            LeadHandler.updateAccCont(Trigger.new,Trigger.oldMap);
        }
    }
}