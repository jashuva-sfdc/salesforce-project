public class ProductComplaintHandler {

    public static void followUpServiceRequest(List<Product_Complaint__c>lstProd){
        if(lstProd !=null){
            
            List<Product_SLA_Configuration__mdt> mdtLst =[SELECT Product_Category__c,SLA_Hours__c FROM Product_SLA_Configuration__mdt
                                                         WHERE Active__c =TRUE];
            //Add the SLA Hours and Category into the Map 
            Map<String,Decimal> slaMap =new Map<String,Decimal>();
            for(Product_SLA_Configuration__mdt prod:mdtLst){
                slaMap.put(prod.Product_Category__c,prod.SLA_Hours__c);
            }
            
            List<Service_Request__c> lstService =new List<Service_Request__c>();
            
            for(Product_Complaint__c complaint:lstProd){
                if(complaint.Severity__c =='Critical'){
                    Service_Request__c service =new Service_Request__c();
                        service.Product_Complaint__c=complaint.Id;
                        service.Account__c=complaint.Account__c;
                    	service.Product_Category__c =complaint.Product_Category__c;
                    	service.Status__c ='New';//Intial Status
                    	Decimal slaHours =slaMap.get(complaint.Product_Category__c); //based on product category assing the SLA Hour 
                   		
                    if(slaHours !=null){
                         service.SLA_Hours__c =slaHours;
                         service.SLA_Due_Date__c =System.now().addHours(Integer.valueOf(slaHours));
                    }
                    lstService.add(service);
                } 
            }
            if(!lstService.isEmpty()){
                Insert lstService;
            }
        }
    }
}