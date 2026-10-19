@isTest
public class CustomOrderItemHandlerTest {

    @isTest
    public static void testCustomOrder(){
     Order__c order =new Order__c();
        order.Name='Test Order';
        Insert order;
        
        Order_Item__c item=new Order_Item__c();
        item.Amount__c=500;
        item.Custom_Order__c=order.Id;
        Test.startTest();
        Insert item;
        Test.stopTest();
        
        Order__c oc=[SELECT Id,Total_Order_Items_Amount__c FROM Order__c LIMIT 1];
        System.assertEquals(oc.Total_Order_Items_Amount__c,item.Amount__c);
    }
}