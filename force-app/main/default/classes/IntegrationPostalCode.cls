public class IntegrationPostalCode {

        public String pincode{set;get;}
   	    public List<String> places{set;get;}

   
        
        public void getPostalDetails(String pincode){
             
            places=new List<String>();
		    // https://api.postalpincode.in/pincode/
		    String endPoint='https://api.postalpincode.in/pincode/'+pincode;
		    HTTP protocol =new HTTP();
			
			HTTPRequest request =new HTTPRequest();
						request.setEndpoint(endPoint);
						request.setMethod('GET');  
            //Response Once the Request Intialized
            HTTPResponse response=protocol.send(request);
            String body=response.getBody();
            //DeSerailize the Data
            System.JSONParser parser =JSON.createParser(body);
            while( parser.nextToken() !=null){
            	
                if(parser.getText()=='Name'){
                    parser.nextToken();
                    places.add(parser.getText());     
                } else if(parser.getText()=='BranchType'){
                    parser.nextToken();
                    places.add(parser.getText());  
                }
            }
           
            for(String names:places){
                System.debug('Name :'+names);
            }
        }
}