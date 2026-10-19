trigger CustomOrderItemTrigger on Order_Item__c (after insert,after update,after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CustomOrderItemHandler.updateOrder(Trigger.new,null);
        }
        if(Trigger.isUpdate){
          CustomOrderItemHandler.updateOrder(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isDelete){
         CustomOrderItemHandler.updateOrder(Trigger.old,null);   
        }
    }
}