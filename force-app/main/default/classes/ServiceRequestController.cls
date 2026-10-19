public class ServiceRequestController {
    
	@AuraEnabled(cacheable =true)
    public static List<ContentDocumentLink> getServiceFiles(Id serviceRequestId){
        List<ContentDocumentLink> result =[SELECT Id,LinkedEntityId, ContentDocument.Title,ContentDocument.FileType,
                                           ContentDocument.LatestPublishedVersionId,
                                           ContentDocument.LatestPublishedVersion.ContentSize,
                                           ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                                           ContentDocument.LatestPublishedVersion.CreatedDate,
                                           ContentDocument.LatestPublishedVersion.Checksum
                                           FROM ContentDocumentLink
                                           WHERE LinkedEntityId =:serviceRequestId];
        return result;
            
    }
    @AuraEnabled
    public static void deleteAllFiles(List<Id> contentDocumentId){
        List<ContentDocumentLink> contentFiles=[SELECT Id FROM ContentDocumentLink 
                                              WHERE Id =: contentDocumentId];
        if(!contentFiles.isEmpty()){
          delete contentFiles;   
        }
    }
}