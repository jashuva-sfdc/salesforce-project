public class ApexSerialization {

    public String stName;
    public Integer Age;
    public Date currentDate;
    public void serializeData(){
        Integer age =25;
        //Serialize the Integer into String
        String sAge=JSON.serialize(age);
        System.debug('STRING FORMAT AGE : '+sAge);
        Decimal marks=250.05;
        String sMarks=JSON.serialize(marks);
        System.debug('SERIALIZING THE MARKS INTO STRING '+sMarks);
        
    }
}