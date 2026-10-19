@isTest
public class AsyncOperationsHandlerTest {

    @isTest
    public static void testFuture(){
       User userInfo=[SELECT Id,FirstName,LastName,UserName,Email,Alias,IsActive FROM User
                       Where UserName =: 'testing@gmail.com'
              		  LIMIT 1];
        Test.startTest();
          userInfo.IsActive=false;
        
        //Create a New Contact Record giving the same details of User
        Contact con =new Contact();
        con.FirstName=userInfo.FirstName;
        con.LastName=userInfo.LastName;
        con.Email=userInfo.Email;
        
        Insert con;
        Test.stopTest();
    }
}