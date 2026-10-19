@isTest
public class CaseBatchHandlerTest {
    @isTest
    static void testCaseBatchHandler() {

        // 1. Create a test User
        Profile p = [ SELECT Id FROM Profile WHERE Name = 'Standard User'LIMIT 1 ];

        User testUser = new User(FirstName = 'Test',LastName = 'User', Alias = 'tuser',Email = 'testuser@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com', ProfileId = p.Id,TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_IN',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US'
        );

        insert testUser;


        // 2. Create an Open Case
        Case openCase = new Case( Subject = 'Test Open Case',Status = 'New',Origin = 'Phone',OwnerId = testUser.Id);

        // 3. Create a Closed Case
        Case closedCase = new Case( Subject = 'Test Closed Case',Status = 'Closed',Origin = 'Phone',OwnerId = testUser.Id);

        insert new List<Case>{openCase,closedCase};

        // 4. Put both Case Ids into a Set
        Set<Id> caseIds = new Set<Id>{openCase.Id, closedCase.Id};

        // 5. Create the Batch class
        CaseBatchHandler batch = new CaseBatchHandler(caseIds);
        // 6. Execute the Batch
        Test.startTest();
        Database.executeBatch(batch, 5);
        Test.stopTest();


        // 7. Verify that the Open Case still exists
        Case resultCase = [SELECT Id, Status, OwnerId
            				FROM Case
            				WHERE Id = :openCase.Id];

        System.assertEquals('New', resultCase.Status);
        System.assertEquals(testUser.Id, resultCase.OwnerId);


        // 8. Verify that the Closed Case was not processed
        Case closedResult = [
            SELECT Id, Status, OwnerId
            FROM Case
            WHERE Id = :closedCase.Id
        ];

        System.assertEquals('Closed', closedResult.Status);
        System.assertEquals(testUser.Id, closedResult.OwnerId);
    }
}