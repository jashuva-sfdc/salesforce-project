trigger CaseTrigger on Case (after insert,after delete,after update)
{
    Set<Id> currentCaseId =new Set<Id>();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CaseHandler.insertCount(Trigger.new);
            
            for(Case cs:Trigger.new){
                if(cs.Status !='Closed'){
                    currentCaseId.add(cs.Id);
                }  
            }
        }
        if(Trigger.isUpdate){
            for(Case cs:Trigger.new){
                Case oldCase=Trigger.oldMap.get(cs.Id);
                if(cs.Status !='Closed'  && oldCase.Status !='Closed'){
                    currentCaseId.add(cs.Id);
                }  
            }
        }
        if(!currentCaseId.isEmpty()){
            CaseBatchHandler batch=new CaseBatchHandler(currentCaseId);
            Database.executeBatch(batch,5);
        }
        if(Trigger.isDelete){
            CaseHandler.insertCount(Trigger.old);
        }
        if(Trigger.isUpdate){
            CaseHandler.updateCount(Trigger.new,Trigger.oldMap);
            CaseHandler.sendEmailToUser(Trigger.new,Trigger.oldMap);
            
        }
    }
    
}