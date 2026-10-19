public class ServiceRequestHandler {

    //while creating or updating owenrs to the records based on their limit preventing.
    public static void validateOwnerLimit(List<Service_Request__c> lstService,Map<Id,Service_Request__c>mapService){
         //adding the record owner id based on this owner id we have to get,how many service requst are assigned.
        Set<Id> userRelId =new Set<Id>(); 
        for(Service_Request__c service:lstService){
            if(mapService ==NULL){
                 if(service.OwnerId !=null){
                    userRelId.add(service.OwnerId);
                  }     
            }else{
                Service_Request__c oldUserId=mapService.get(service.Id);
                //during the updating also we have to add both new user id old User id
                 if(service.OwnerId !=null){
                userRelId.add(service.OwnerId);
            	}     
                if(service.OwnerId !=NULL && service.OwnerId !=oldUserId.OwnerId){
                    userRelId.add(oldUserId.OwnerId);
                }
            }
        }
        //Based on the record owener get the Users 
        Map<Id,User> userMap =new Map<Id,User>([SELECT Id,ProfileId FROM User WHERE Id IN :userRelId]);
        
        /*Get the Custom Settings Configuration 
        	Org Level =default ,
			Profile Level, User Level
        */
        //Get the User level Limitations and below map is going to store the user id and entire the record, rather than custom settings id 
    
        Map<Id,Service_Request_Settings__c> userCSettingMap=new Map<Id,Service_Request_Settings__c>();
        for(Service_Request_Settings__c csUser:[SELECT Id,SetUpOwnerId,Maximum_Active_Service_Requests__c
                                               FROM Service_Request_Settings__c WHERE SetUpOwnerId IN: userRelId]){
            userCSettingMap.put(csUser.SetupOwnerId,csUser);
        }
        
		/*Get the profile Settings based on profile Id
		 *First of all retrive the ProfileId from User
		 * Then Query the Data From Custom Settings based on the ProfileId
		 */  
		Set<Id> profileId =new Set<Id>();
        for(User user:userMap.values()){
           profileId.add(user.ProfileId); 
        }	
        //It is going to store the ProfileId with Entire records
		Map<Id,Service_Request_Settings__c> profileCSettingMap=new Map<Id,Service_Request_Settings__c>();
    	for(Service_Request_Settings__c settings:[SELECT Id,SetUpOwnerId,Maximum_Active_Service_Requests__c
												  FROM Service_Request_Settings__c
                                                  WHERE SetUpOwnerId IN:profileId])
        {
         profileCSettingMap.put(settings.SetupOwnerId,settings);                                             
        }    
	
		//Get the Organization Level
		Service_Request_Settings__c orgSettings=Service_Request_Settings__c.getOrgDefaults();
        Integer organizationLimt =0;
        if(orgSettings !=NULL && orgSettings.Maximum_Active_Service_Requests__c !=NULL){
            organizationLimt=Integer.valueOf(orgSettings.Maximum_Active_Service_Requests__c);
        }
        
        //Determine the applicabable limit for each level 
        Map<Id,Integer> ownerLimitMap =new Map<Id,Integer>();
        for(Id ownerId:userRelId){
            Integer applicabableLimits =organizationLimt;
            if(ownerId !=NULL){
                //Get the User Details FROM userMap
                User ownerUserId=userMap.get(ownerId);
                if(ownerUserId !=NULL){
                    //check the profile and assign the limiation
                    Service_Request_Settings__c profileSettings=profileCSettingMap.get(ownerUserId.ProfileId);
                    if(profileSettings !=NULL && profileSettings.Maximum_Active_Service_Requests__c !=NULL){
                        applicabableLimits =Integer.valueOf(profileSettings.Maximum_Active_Service_Requests__c);
                    }
                    //check the User Level configurations and assign the value
                    Service_Request_Settings__c userSettings=userCSettingMap.get(ownerId);
                    if(userSettings !=NULL && userSettings.Maximum_Active_Service_Requests__c !=NULL){
                        applicabableLimits =Integer.valueOf(userSettings.Maximum_Active_Service_Requests__c);
                    }
                }
            }
            ownerLimitMap.put(ownerId,applicabableLimits);
        }
        //Count Existing Service Request Records
        Map<Id,Integer> existingServiceCount=new Map<Id,Integer>();
        for(AggregateResult ar:[SELECT OwnerId ownerIds,Count(Id) totalCount FROM Service_Request__c 
                               WHERE OwnerId IN:userRelId AND
                               Status__c IN('New','Assigned','In Progress')
                               GROUP BY OwnerId]){
            existingServiceCount.put((Id)ar.get('ownerIds'),(Integer)ar.get('totalCount'));
        }
        //validate the record assining
        for(Service_Request__c service :lstService){
            if(service.OwnerId !=NULL){
            	
                //Get the current Record Count
                Integer existingRecordCount= existingServiceCount.get(service.OwnerId); 
                //Get the LIMITATION COUNT
                Integer allowedLimit = ownerLimitMap.get(service.OwnerId);
                
                //existingRecordCount this count is currently having the records count so for new records it wont includes
                //will add 1 to the existingRecordCount 
                Integer totalRecordsCount =existingRecordCount+1;
                if(totalRecordsCount > allowedLimit){
                    service.addError('Service Request cannot be assigned to this user.The user has reached the maximum allowed active ' +
                   					 'Service Requests limit of ' +allowedLimit + '.');
                }
            } 
        }
    }
}