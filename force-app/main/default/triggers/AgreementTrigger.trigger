trigger AgreementTrigger on Agreement__c (before insert,before update,after insert,after update,after delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            AgreementHelper.calcualteEndDate(Trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            AgreementHelper.sumAgreementValue(Trigger.new,null);
        }
        if(Trigger.isUpdate){
            AgreementHelper.sumAgreementValue(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isDelete){
            AgreementHelper.sumAgreementValue(Trigger.old,null);
        }
    }
}