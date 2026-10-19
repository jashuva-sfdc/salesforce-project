public class JSONExamples {

    	public String jsonData{get;set;}
        public Map<String,Object> complexData {get;set;}  
            String name;
    		Integer Age;
    		
            public JSONExamples(){
                jsonData='{"Name":"Raju","Age":25,"Phone":"8887774444"}';
                //complexData='{"Name":"Raju","Age":25,"Phone":"8887774444","Contact":[{"FirstName":"Raju","LastName":"Singh"}],"Contact":[{"FirstName":"Raju","LastName":"Singh"}]}';
           
             System.JSONParser jsp=JSON.createparser(jsonData);
                while(jsp.nextToken() !=null){
                    String fieldName=jsp.getText();
                    if(jsp.getText()=='Name'){
                        name=jsp.getText();
                    }
                    if(jsp.getText()=='Age'){
                        Age=Integer.valueOf(jsp.getText());
                    }
                }
                 System.debug('Name is :'+name);
   				 System.debug('Age is :'+Age);
            } 
   
}