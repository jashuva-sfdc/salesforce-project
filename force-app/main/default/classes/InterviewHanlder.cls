public class InterviewHanlder {
    public static void roundsSequence(List<Interview__c> lstInt){
    // Step 1: Collect Candidate Ids from Trigger.new records
        Set<Id> candIds = new Set<Id>();
        for(Interview__c intView : lstInt) 
        {
            if (intView.Candidate__c != null) {
                candIds.add(intView.Candidate__c);
            }
        }
        // Step 2: Query To get the status for completed and candidates details 
        List<Interview__c> intRounds = [
            SELECT Id, Candidate__c, Interview_Round__c, Status__c
            FROM Interview__c
            WHERE Status__c = 'Completed'
            AND Candidate__c IN :candIds
        ];

        // Step 3: Store completed rounds in a Map
        // Key   -> Candidate Id
        // Value -> Set of completed rounds
        // Example:
        // Candidate1 => {'Round 1', 'Round 2'}
        // Candidate2 => {'Round 1'}
       Map<Id,Set<String>> candidateCompletedRounds=new Map<Id,Set<String>>();
        
        for(Interview__c intView:intRounds)
        {
            //add the candidate inside the map is he is not present
            if(!candidateCompletedRounds.containsKey(intView.Candidate__c)){
                candidateCompletedRounds.put(intView.Candidate__c,new Set<String>());
            }
            //Get the candidate and add into the Set for reference of the interview rounds
            candidateCompletedRounds.get(intView.Candidate__c).add(intView.Interview_Round__c);
        }
        for(Interview__c intView:lstInt){
            //This Variable for reference to validate the condition, to complete the previous round before moving to next round
            String previousRound;
            if(intView.Interview_Round__c =='Round 2'){
                previousRound='Round 1';
            }else if(intView.Interview_Round__c =='Round 3'){
                previousRound ='Round 2';
            }
             if(previousRound ==null){
                continue;
            }
            //If Candidate is not completed the round OR candidte is not containing the previous rounds
           if(!candidateCompletedRounds.containsKey(intView.Candidate__c)||
              !candidateCompletedRounds.get(intView.Candidate__c).contains(previousRound))
           {
               intView.Interview_Round__c.addError(previousRound+'needs to complete before moving to '+intView.Interview_Round__c);
           }
        }
        }
        //If updating in reverse direction 
        public static void preventReverse(List<Interview__c> newList,Map<Id,Interview__c> oldMap){
           
            for(Interview__c intNew:newList){
                Interview__c oldId=oldMap.get(intNew.Id);
                 // Run validation only when Interview Round is actually changed.
                // If the user is only changing Status__c (for example Completed -> Selected),
                // this condition skips the validation.
                if (intNew.Interview_Round__c == oldId.Interview_Round__c) {
                    continue;
                }
                 //The Purpose of Calling this method converting string to Integer --> Round 1 TO 1       
                Integer newRound=convertRoundToNumber(intNew.Interview_Round__c);
                Integer oldRound=convertRoundToNumber(oldId.Interview_Round__c);
                
                if(newRound < oldRound){
                   intNew.Interview_Round__c.addError( 'You cannot move back from ' +
                    intNew.Interview_Round__c + ' to ' + oldId.Interview_Round__c + '.');
                }
                
            }
        }
        public static Integer convertRoundToNumber(String roundName){
            if(roundName =='Round 1') return 1;
            if(roundName =='Round 2') return 2;
            if(roundName =='Round 3') return 3;
            return 0;
        }
    }