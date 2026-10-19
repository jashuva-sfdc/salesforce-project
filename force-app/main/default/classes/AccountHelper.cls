public class AccountHelper {
    public static void createContact(List<Account> newAcc){
        List<Contact> conLst =new List<Contact>();
        for(Account acc:newAcc){
            Contact con =new Contact();
            con.LastName =acc.Name+' Test Record';
            con.AccountId=acc.Id;
            conLst.add(con);
        }
        if(!conLst.isEmpty()){
            insert conLst;
        }
    }
}