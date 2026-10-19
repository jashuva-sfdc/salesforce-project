trigger ProductComplaintTrigger on Product_Complaint__c (after insert) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ProductComplaintHandler.followUpServiceRequest(Trigger.new);
        }
    }
}