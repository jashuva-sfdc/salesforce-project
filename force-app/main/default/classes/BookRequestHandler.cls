public class BookRequestHandler {
    public static void shareRecordsToBookOwner(List<Book_Request__c> lstBookRequest){
        //collect the releated bookID's
        Set<Id> bookIds =new Set<Id>();
        for(Book_Request__c br:lstBookRequest){
            if(br.Book__c !=null){
                bookIds.add(br.Book__c);
            }
        }
        //collect the releated books 
        Map<Id,Book__c> mapBook =new Map<Id,Book__c>([SELECT Id, OwnerId FROM Book__c where Id IN: bookIds]);
        
        List<Book_Request__Share> shareObject=new List<Book_Request__Share>();
        
        for(Book_Request__c br:lstBookRequest){
            if(mapBook.containsKey(br.Book__c)){
                //Parent Record Owner ----Account -->User(Principal)
                Id ownerId=mapBook.get(br.Book__c).OwnerId;
                
               	Book_Request__Share share =new Book_Request__Share();
                share.ParentId =br.Id;
                share.UserOrGroupId=ownerId; //here I'm sharing the Book_Request record to the Book Record Owner
                share.AccessLevel='Edit';
                //share.RowCause='Manual';
                share.RowCause =Schema.Book_Request__Share.RowCause.Book_Owner_Access__c;
                shareObject.add(share);
            }
        }
        if(!shareObject.isEmpty()){
           try {
              Database.SaveResult[] results = Database.insert(shareObject, false);
            
            for(Database.SaveResult sr : results){
                if(sr.isSuccess()){
                    System.debug('SUCCESS');
                    System.debug(sr.getId());
                }else{
                    for(Database.Error err : sr.getErrors()){
                        System.debug('StatusCode : '+err.getStatusCode());
                        System.debug('Message : '+err.getMessage());
                     }
                  }
               }
            } catch (DmlException e) {
                System.debug('Message: ' + e.getMessage());
            
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    System.debug('Status Code: ' + e.getDmlStatusCode(i));
                    System.debug('Fields: ' + e.getDmlFields(i));
                    System.debug('Message: ' + e.getDmlMessage(i));
                }
            }
        }
    }
}