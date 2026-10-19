public class BookInfoAgent {

    @InvocableMethod(label='Book Info Action'
                    description='This is used to collect all the details about the books based on the book name')
    public static List<String> booksDetails(List<String> bookName){
        
        return new List<String>();
    }
}