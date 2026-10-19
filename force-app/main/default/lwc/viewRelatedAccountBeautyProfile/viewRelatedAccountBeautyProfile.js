import Status_Field from '@salesforce/schema/Case.Status';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';

import Beacuty_Profile_Object from '@salesforce/schema/Beauty_Profile__c';
import Skin_Type_Field from '@salesforce/schema/Beauty_Profile__c.Skin_Type__c';
import Hair_Type_Field from  '@salesforce/schema/Beauty_Profile__c.Hair_Type__c';

export default class ViewRelatedAccountBeautyProfile extends LightningElement {

    //This will gives the current record id 
    @api recordId;
    hairedOptions=[];
    skinTypeOptions=[];
    //Based on that ID we are getting the data 

    @wire(getObjectInfo,{
        objectApiName:Beacuty_Profile_Object
    })
    objectInfo;
    @wire(getPicklistValues,{ 
        recordTypeId: '$objectInfo.data.defaultRecordTypeId', 
        fieldApiName: Skin_Type_Field 
    } ) 
    skinTypePicklistValue({data,error}){
        if(data){
            this.skinTypeOptions=data.values;
            console.log('Skin Type Picklist Value',data)
        }else if(error){
            console.error(error);
        }
    }
    @wire(getPicklistValues,{
        recordTypeId:'$objectInfo.data.defaultRecordTypeId',
        fieldApiName: Hair_Type_Field
    })
    hairTypePickListValues({data,error}){
        if(data){
            this.hairedOptions = data.values;
        }else if(error){
            console.error(error);
        }
    }
    @wire(getRecord,{
        recordId:'$recordId',
        fields:[Status_Field]
        }
    )
    caseRecord;
    get isReadOnly(){
        return this.caseRecord.data ?
        getFieldValue(this.caseRecord.data,Status_Field) ==='Closed':false;
    }



}