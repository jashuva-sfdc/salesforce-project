public class HospitalUtility {
  public static string name;
    public String getHospitalName(){
        name='CarePlus Hospital';
        return name;
    }
    public Integer getDocCount(){
        Integer count=10;
        return count;
    }
    public String getWelcomMessage(String patientName){
        String message='Hello '+patientName+' Welcom To The '+name;
        return message;
    } 
}