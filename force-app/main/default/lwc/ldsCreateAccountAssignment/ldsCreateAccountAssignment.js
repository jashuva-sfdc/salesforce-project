import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { LightningElement, track, wire } from 'lwc';
import Account_Object from '@salesforce/schema/Account'
import Industry_Field from '@salesforce/schema/Account.Industry';
import { createRecord } from 'lightning/uiRecordApi';
import{ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LdsCreateAccountAssignment extends LightningElement {
    recordTypeId;
    industryOptions=[];

    accountInput={};
    
    handleChangeAccInput(event){
        let fieldName=event.target.name;
        let fieldValue=event.target.value;
        this.accountInput[fieldName]=fieldValue;
    }
   //If you want to give the reocrdTypeId is also dynamcially then use getObjectInfo
   @wire(getObjectInfo,{objectApiName:Account_Object})
   wiredAccountObj({error,data}){
    if(data){
        this.recordTypeId=data.defaultRecordTypeId;
    }else if(error){
    console.error('Error', error);
   }
  }
    //Getting the Industry Picklist values
    @wire(getPicklistValues,{recordTypeId:'$recordTypeId',fieldApiName:Industry_Field})
    wiredIndustryResult({error,data}){
        if(data){
            console.log('Data',data)
            this.industryOptions=data.values;
        }else if(error){
            console.error('Error',error);
        }
    }

    //Oncce getting all the picklist values then create Account
    handleClick(){
        console.log('Inside the button click');
        let fields=this.accountInput
        const accountRecords ={
                apiName:Account_Object.objectApiName,
                fields
            }
        createRecord(accountRecords)
        .then((result)=>{
            console.log('Result',result)
            let recordId=result.id;
            console.log('Record ID is :',recordId);
            this.dispatchEvent(new ShowToastEvent(
                {
                   title:'Succes',
                   message:'Record Created Succesfully'+recordId,
                   variant:'success' 
                }
            ))
        })
        .catch((error)=>{
            console.error('Error Message',error);
            this.dispatchEvent(new ShowToastEvent(
                {
                   title:'Error',
                   message:'Error Occured Record Not Created',
                   variant:'error' 
                }
            ))
        })
    }
}