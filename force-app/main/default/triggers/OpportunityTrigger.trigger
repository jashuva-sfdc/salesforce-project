trigger OpportunityTrigger on Opportunity (before insert,after update,after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            OpportunityHandler.preventChoosingOpp(Trigger.new);
        }
    }
    
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            OpportunityHelper.createAgreement(Trigger.new,Trigger.oldMap);
            OpportunityHelper.updateAccountField(Trigger.new, Trigger.oldMap);
        }   
    }
}

/*
 *if(!OpportunityRecursiveHelper.isExecuted){
             OpportunityRecursiveHelper.isExecuted=true;
        
            if(Trigger.isInsert){
                OpportunityHandler.sumOfOpportunity(Trigger.new,null);
                OpportunityHandler.updateContactLastName(Trigger.new);
            }
            if(Trigger.isDelete){
                OpportunityHandler.sumOfOpportunity(Trigger.old,null); 
            }
            if(Trigger.isUpdate){
               // AsyncOperationsHandler.updateContactScore(Trigger.new);
                OpportunityHandler.sumOfOpportunity(Trigger.new,Trigger.oldMap);
                
                //
                OpportunityHandler.updateAccount(Trigger.new, Trigger.oldMap);   
             }
        } 
 * 
 * 
 * 
*/