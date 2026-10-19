public class LeadHandler {

    //once the lead is converted then updating the newly created account and contacts values
    public static void updateAccCont(List<Lead>lstLead,Map<Id,Lead>oldLead){
        if(lstLead !=null){
            
            //Step-1 Collect the Account and contact Id
            Map<Id,Lead> convertedAccId =new Map<Id,Lead>();
            Map<Id,Lead> convertedConId=new Map<Id,Lead>();
            for(Lead ld:lstLead){
                Lead oldValue=oldLead.get(ld.Id);
                //with the same record Id if the status is newly converted and old status is not converted then only
                //take the id's becuase if the status is already converted means it is converted  
                if(ld.IsConverted ==true && oldValue.IsConverted !=true )//oldValue.isConverted !=true (false)
                {
                    if(ld.ConvertedAccountId !=null){
                    convertedAccId.put(ld.ConvertedAccountId,ld);    
                    }
                    if(ld.ConvertedContactId !=null){
                     convertedConId.put(ld.ConvertedContactId,ld);   
                    }
                }
            }
            if(convertedAccId.isEmpty() && convertedConId.isEmpty() ){
                return;
            }
			//If u want to give the lead details to the contact we can give it else give custom values to check
			//this approach is bulkified
			//List<Account> accToUpdate=new List<Account>();
            //List<Contact> conToUpdate=new List<Contact>();
            List<sObject>accConBoth=new List<sObject>(); //But this approach is not recommonded 
            for(Id accId:convertedAccId.keySet()){
                Lead ldData=convertedAccId.get(accId);//make this one as reference and assign the values if u need
                Account acc=new Account(Id=accId,
                                       Name='Custom Name');
                accConBoth.add(acc);
            }
            
            for(Id conId:convertedConId.keySet()){
                Lead ldData=convertedConId.get(conId);
                Contact con=new Contact(Id=conId,LastName='Created By Apex');
                accConBoth.add(con);
            }
            if(!accConBoth.isEmpty()){
                update accConBoth;
            }
        }
    }
    
}