public class DashboardController {

    @AuraEnabled(cacheable=true)
    public static DashboardWrapper getAllDetails(){
        DashboardWrapper result =new DashboardWrapper();
         
        //Count the total Patients and assign that to data to totalPatients;
        result.totalPatients=[SELECT Count() from Patient__c];
        
        result.totalDoctors=[SELECT COUNT() FROM Doctor__c];
        
        result.todayAppointments=[SELECT COUNT() FROM Appointment__c where Appointment_Date__c=TODAY];
        
        result.pendingBills=[SELECT COUNT() FROM Billing__c where Payment_Status__c ='Pending'];
        
        //calculate total revenue
        AggregateResult[] revenueResult =[SELECT SUM(Total_Amount__c) totalAmount FROM Billing__c WHERE Payment_Status__c='Paid'];
        if(!revenueResult.isEmpty() && revenueResult[0].get('totalAmount')!=null){
            result.totalRevenue=(Decimal)revenueResult[0].get('totalAmount');
        }
        
        return result;
        
    }
    
    public class DashboardWrapper {
        //The properties inside DashboardWrapper are allowed to be sent to the client side bcz already in the about method we are sending
        //data to lwc side so what data we are sending that is the reason we are declaring the variable as @AuraEnabled
        //Here mulitple types of data we are returing i.e is the reason we created the wrapper classses?
        @AuraEnabled()
        public Integer totalPatients;
        @AuraEnabled()
        public Integer totalDoctors;
        @AuraEnabled()
        public Integer todayAppointments;
        @AuraEnabled()
        public Integer pendingBills;
        @AuraEnabled()
        public Decimal totalRevenue;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getLatestAppointments(){
        List<Appointment__c> latestData =[SELECT Id,Name,Status__c,Appointment_Date__c,Patient__r.Name,Doctor__r.Name FROM Appointment__c
                                          Order by Appointment_Date__c Desc LIMIT 5];
        return latestData;
    }
    @AuraEnabled
    public static List<Patient__c> searchPatients(String patientName){
       List<Patient__c> patientDetails =[SELECT Id,Name,Age__c,Gender__c,Email_Address__c FROM Patient__c 
                                        where Name LIKE :('%'+patientName+'%')]; 
        return patientDetails;
    }
}