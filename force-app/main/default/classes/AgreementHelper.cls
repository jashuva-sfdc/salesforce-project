public class AgreementHelper {
    //Calculating The End Date Based on Agreement Period 
    public static void calcualteEndDate(List<Agreement__c> lstAg){
        for(Agreement__c ag:lstAg){
            if(ag.Agreement_Period__c !=null && ag.Agreement_Start_Date__c !=null){
                Date endDate;
                if(ag.Agreement_Period__c =='1 Year'){
                  endDate=ag.Agreement_Start_Date__c.addYears(1);  
                }else if(ag.Agreement_Period__c =='2 Years'){
				 endDate=ag.Agreement_Start_Date__c.addYears(2);  
                }else if(ag.Agreement_Period__c =='3 Years'){
                 endDate=ag.Agreement_Start_Date__c.addYears(3);  
                }
                // If End Date comes/falls on Sunday, move it to Saturday
                if(endDate !=null){
                    //Converting the endDate into fomrat 
                   DateTime dt=DateTime.newInstance(endDate.year(),endDate.month(),endDate.day());
                    String dayOfWeek=dt.format('EEEE'); 
                    if(dayOfWeek =='Sunday'){
                        endDate=endDate.addDays(-1);//Move FROM Sunday TO Saturday
                    }
                }
                ag.Agreement_End_Date__c=endDate;
            }
        }
    }
    
    
    //Calculating the related Opportunity  Agreement Values and Displaying the Sum in Opportunity 
    public static void sumAgreementValue(List<Agreement__c> lstAgr,Map<Id,Agreement__c>mapAgr){
        if(lstAgr !=null)
        {
            Set<Id> oppRelId =new Set<Id>();
            if(mapAgr == null){
                for(Agreement__c newAgr:lstAgr){
                    if(newAgr.Opportunity__c !=null){
                        oppRelId.add(newAgr.Opportunity__c);
                    }  
                } 
            } 
            else{
                for(Agreement__c agr:lstAgr)
                { 
                    Agreement__c oldAg=mapAgr.get(agr.Id);  
                    // Always add the new Opportunity
                    if(agr.Opportunity__c != null){
                        oppRelId.add(agr.Opportunity__c);
                    } 
                    if(oldAg.Opportunity__c !=null && agr.Opportunity__c != oldAg.Opportunity__c) //If The Opporunity Record is Changed then add those new record also
                    { 
                        oppRelId.add(oldAg.Opportunity__c);
                    }
                }  
            }  
         	
            Map<Id,Decimal> sumAgreementValue=new Map<Id,Decimal>();
            for(AggregateResult ar:[SELECT Opportunity__c oppRelatedId,SUM(Agreement_Value__c) totalSum FROM Agreement__c
                                   where Opportunity__c IN:oppRelId 
                                   GROUP By Opportunity__c ]){
              sumAgreementValue.put((Id)ar.get('oppRelatedId'),(Decimal)ar.get('totalSum'));  
            }
            //update in Opportunity
            List<Opportunity> updateOpp=[SELECT Id,Agreement_Value__c FROM Opportunity where Id IN :oppRelId];
            for(Opportunity opp:updateOpp){
                opp.Agreement_Value__c = sumAgreementValue.containsKey(opp.Id)? sumAgreementValue.get(opp.Id):0;
            }
            if(!updateOpp.isEmpty()){
               update updateOpp;
            }
        } 
    }
}