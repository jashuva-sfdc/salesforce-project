public class BookHandler {
    //Prevent the Duplicate Books Creation
    public static void preventDuplicate(List<Book__c> lstBook){
        if(lstBook !=null){
            Set<String> bookName =new Set<String>();
            for(Book__c book:lstBook){
                if(book.Name !=null){
                    bookName.add(book.Name);
                }
            }    
            //Get the existing books with that name 
            List<Book__c> existingBooks=[SELECT Id,Name FROM Book__c WHERE Name IN :bookName WITH USER_MODE];      
            //add the book name into set to compare
            Set<String> existingName =new Set<String>();
            for(Book__c book:existingBooks){
                if(book.Name !=null){
                    existingName.add(book.Name);
                }
            }
            for(Book__c book:lstBook){
                if(existingName.contains(book.Name)){
                    book.addError('Duplicate Book Found with Same Name '+book.Name);
                }
            }
            // 4. Check duplicates within the same transaction
            Set<String> newBookNames = new Set<String>();
            for(Book__c book : lstBook){
                if(book.Name != null){
                    if(newBookNames.contains(book.Name)){
                        book.addError('Duplicate Book Found in the same transaction: ' + book.Name);
                    }
                    else{
                        newBookNames.add(book.Name);
                    }
                }
            }   
        }
    }
}