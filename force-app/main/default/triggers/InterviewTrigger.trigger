trigger InterviewTrigger on Interview__c (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert)
        {
            InterviewHanlder.roundsSequence(Trigger.new);
        }
        if(Trigger.isUpdate){
            InterviewHanlder.preventReverse(Trigger.new,Trigger.oldMap);
        }
    }
}