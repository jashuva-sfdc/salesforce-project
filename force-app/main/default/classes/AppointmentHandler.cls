public class AppointmentHandler {
   
    public static void uniqueAppointmentDate(List<Appointment__c> lstApp){
        //STEP -1 Fetching the DOC ID and Given Appointment Date and Time 
        Set<Id> docId=new Set<Id>();
        Set<Date> appointmentDate=new Set<Date>();
        Set<Time> appointmentTime=new Set<Time>();
        for(Appointment__c app:lstApp){
            if(app.Doctor__c !=null){
                docId.add(app.Doctor__c);
                appointmentDate.add(app.Appointment_Date__c);
                appointmentTime.add(app.Appointment_Time__c);
            }
        }
        //Fetch The Patients are having the appointment
       List<Appointment__c> existingAppointments=[SELECT Doctor__c, Appointment_Date__c,Appointment_Time__c FROM Appointment__c
                                                  where Doctor__c IN: docId AND 
                                                 Appointment_Date__c IN : appointmentDate AND
                                                 Appointment_Time__c IN :appointmentTime];
        //STEP -2 Store with all 3 fields data into a single line
        Map<String,Appointment__c> existingMap =new Map<String,Appointment__c>();
        for(Appointment__c app:existingAppointments){
            //making 3 fields data into a single record
			//Doc Name ->ABC Dr  AppointmentDate 27-06-2001 Appointment Time 10:23:00
			//With a single Line ABC Dr27-06-200110:23:00
			String key =app.Doctor__c +'-'+String.valueOf(app.Appointment_Date__c)+'-'+String.ValueOf(app.Appointment_Time__c);
            existingMap.put(key,app);
            
        }
        
        //FINAL STEP -> Throw an validation rule
        for(Appointment__c newApp:lstApp){
            String key =newApp.Doctor__c +'-'+String.valueOf(newApp.Appointment_Date__c)+'-'+String.ValueOf(newApp.Appointment_Time__c);
            if(existingMap.containsKey(key)){
                Appointment__c currentId=existingMap.get(key);
                if(newApp.Id !=currentId.Id){
                 newApp.addError('This doctor already has an appointment at the selected date and time.');  
                }
            }
        } 
   }
    //Creating The Billing Record Upon any Appointment has been created
    public static void createBilling(List<Appointment__c> lstApp,Map<Id,Appointment__c>mapApp){
        if(lstApp !=null){
            List<Billing__c> lstBilling =new List<Billing__c>();
            for(Appointment__c app:lstApp){
                if(app.Doctor__c ==null || app.Patient__c ==null){
                  continue;
                }
               Appointment__c oldApp=mapApp.get(app.Id);
                System.debug('Appointment Old Version Status '+oldApp.Status__c);
                System.debug('Appointment New Version Status '+app.Status__c);
                if(app.Status__c =='Completed' && oldApp.Status__c !=app.Status__c){
                    Billing__c bl=new Billing__c();
                    bl.Payment_Mode__c='Cash';
                    bl.Payment_Status__c='Pending';
                    bl.Total_Amount__c=500;
                    bl.Appointment__c=app.Id;
                    bl.Patient__c=app.Patient__c;
                    lstBilling.add(bl);
                }
            }
           System.debug('Billing Records To Insert '+lstBilling); 
        if(!lstBilling.isEmpty())
            insert lstBilling;
        }    
    }
    
}