trigger EmailBounceTrigger on EmailMessage (after insert,after update) {
  
    Set<Id> emailIds = new Set<Id>();
        if (Trigger.isInsert) {
            for (EmailMessage newEmail : Trigger.new) {
            if (newEmail.IsBounced && newEmail.ParentId != null) {
                    emailIds.add(newEmail.Id);
                }
            }
        }
        if (Trigger.isUpdate) {
            for (EmailMessage newEmail : Trigger.new) {
                EmailMessage oldEmail = Trigger.oldMap.get(newEmail.Id);
                if (!oldEmail.IsBounced && newEmail.IsBounced && newEmail.ParentId != null) {
                    emailIds.add(newEmail.Id);
                }
            }
        }

    if (!emailIds.isEmpty()) {
        System.enqueueJob( new EmailNoficationBounceQueueable(emailIds) );
    }

}