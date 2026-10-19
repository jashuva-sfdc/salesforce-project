public class CustomOrderItemHandler {
 
    //when ever orderItem is created,updated OR Deleted update the totalAmount in Custom ORDER  
    public static void updateOrder(List<Order_Item__c> lstOrder,Map<Id,Order_Item__c>mapOrderItem){
        if(lstOrder !=null){
            Set<Id> orderRelId =new Set<Id>();
            if(mapOrderItem ==null){
                for(Order_Item__c item:lstOrder){
                if(item.Custom_Order__c !=null){
                    orderRelId.add(item.Custom_Order__c);
                  }
               } 
            }else {
                for(Order_Item__c item :lstOrder){
                    Order_Item__c oldData=mapOrderItem.get(item.Id);
                    if(item.Custom_Order__c !=null && item.Custom_Order__c !=oldData.Custom_Order__c){
                       orderRelId.add(item.Custom_Order__c); 
                    }
                }
            }
          Map<Id,Decimal> totalAmountMap=new Map<Id,Decimal>();
            for(AggregateResult ar:[SELECT Custom_Order__c orderId, SUM(Amount__c) totalAmount
									 FROM Order_Item__c GROUP By Custom_Order__c ]){
                totalAmountMap.put((Id)ar.get('orderId'),(Decimal)ar.get('totalAmount'));
            }
        //update in Order
        List<Order__c> updateOrder= new List<Order__c>();
            for(Id orderId:orderRelId){
                if(totalAmountMap.containsKey(orderId)){
                 Order__c order=new Order__c(Id=orderId,
                                            Total_Order_Items_Amount__c=totalAmountMap.get(orderId));
                    updateOrder.add(order);
                }
            }
            if(!updateOrder.isEmpty()){
                update updateOrder;
            }
        }
    }
}