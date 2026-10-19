public class PatientCollectionExample {
    public static void collecitonsList(){
        //List of Patient Names 
        List<String> patientNames = new List<String>(); 
        patientNames.add('Ravi'); 
        patientNames.add('Suresh'); 
        patientNames.add('Priya'); 
        System.debug('Patient Names :'+patientNames);
        //2. Set of Departments 
        Set<String> departments = new Set<String>(); 
        departments.add('Cardiology'); 
        departments.add('Neurology'); 
        departments.add('Pediatrics'); 
        System.debug('Departments :'+departments);
        //3. Map of Doctor and Specialization 
        Map<String, String> doctorMap = new Map<String, String>(); 
        doctorMap.put('Dr. Rajesh', 'Cardiology'); 
        doctorMap.put('Dr. Priya', 'Neurology');
        System.debug('Doctors AND Departments '+doctorMap);
    }
}