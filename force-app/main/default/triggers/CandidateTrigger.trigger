trigger CandidateTrigger on Candidate__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            CandidateHandlerBefore.duplicationCheck(Trigger.new);
        }
    }
}