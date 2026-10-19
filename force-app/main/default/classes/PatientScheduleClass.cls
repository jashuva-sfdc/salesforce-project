public class PatientScheduleClass implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.debug('Daily Patient Job Executed');
    }

}