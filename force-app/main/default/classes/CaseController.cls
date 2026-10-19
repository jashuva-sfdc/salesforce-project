public class CaseController {

    @AuraEnabled(cacheable=true)
    public static List<Case> casesWithAccounts(){
        List<Case> lstCases =[SELECT CaseNumber,Status,Origin,Account.Name FROM Case LIMIT 10];
        return lstCases;
    }
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getCaseFiles(Id caseId){
        //LatestPublishedVersion is the Connection between ContentDocument and ContentVersion
        return [SELECT Id,LinkedEntityId,ContentDocumentId,ContentDocument.Title,ContentDocument.FileType,
                ContentDocument.LatestPublishedVersionId,
                ContentDocument.LatestPublishedVersion.ContentSize,
                ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                ContentDocument.LatestPublishedVersion.CreatedDate,
                ContentDocument.LatestPublishedVersion.Checksum 
                FROM ContentDocumentLink where LinkedEntityId =: caseId];
    }
    @AuraEnabled
    public static void confirmDeletion(List<Id> ContentDocumentLinkId){
        if(contentDocumentLinkId == NULL){
            throw new AuraHandledException('No File Selected');
        }
        List<ContentDocumentLink> deleteFile =[SELECT Id FROM ContentDocumentLink WHERE Id =:ContentDocumentLinkId];
        
        Database.DeleteResult[] results=Database.delete(deleteFile,false);
        for(Database.DeleteResult result:results){
             if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    throw new AuraHandledException(
                        'File deletion failed: ' + error.getMessage()
                    );
                }
             }
        }
    }
}