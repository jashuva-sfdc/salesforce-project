import { LightningElement, wire } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import AccountInfo from '@salesforce/apex/AccountController.getAccountDetails';
import updateAccount from '@salesforce/apex/AccountController.updateAccountDetails';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import Account_Object from '@salesforce/schema/Account';
import Industry_Field from '@salesforce/schema/Account.Industry';
export default class AccountDetails extends LightningElement {

 cols =[
   {label:'Name',fieldName:'Name',type:'text',editable:true},
   {label:'Phone',fieldName:'Phone',type:'phone',editable:true},
   {label:'Annual Revenue',
    fieldName:'AnnualRevenue',type:'currency',
    editable:true,
    cellAttributes:{
      alignment:'left'
    }
   },
  {
    label:'Industry',
    fieldName:'Industry',
    type:'picklist',
    typeAttributes:{
      options:{ fieldName:'industryValues'},
      value:{ fieldName:'Industry'},
      context:{ fieldName:'Id'}
    },
    editable:true
  }
 ];
//Get the Object Info and Picklist value
recordTypeId;
industryOptions=[];
@wire(getObjectInfo,{
  objectApiName:Account_Object
})
accountObjectInfo({error,data}){
  if(data){
    this.recordTypeId=data.defaultRecordTypeId;
  }else if(error){
    console.error('Error Occured',error);
  }
}

@wire(getPicklistValues,{
  recordTypeId:'$recordTypeId',
  fieldApiName:Industry_Field
})
industryPicklistValue({error,data}){
  if(data){
    this.industryOptions=data.values.map(industry =>{
      return {
        label:industry.label,
        value:industry.value
      }
    })
  console.log('Industry options',this.industryOptions);
  }else if(error){
    console.error('Error Mesage',error);
  }
}
accountData; //To store the Account Details
wiredResult;//To refresh the wired data we are storing entire result in this property
draftValues=[];//to store the unsaved changes make by the user
  
  @wire(AccountInfo)
  WiredAccountInfo(result){
    this.wiredResult=result;
    const{error,data}=result
    if(data){
        console.log('Wired Data',data);
        this.accountData=data;
        console.log('Account Data',this.accountData);
        this.showToastMessage('Success','Account Data Fetched Successfully','success')

    }else if(error){
        console.log('Error Message',error);
        this.showToastMessage('Error','Error Occured ','error');
    }
  }
//upon clicking on the save button the event is going to collect the input
 async handleOnSave(event){
    const updateAccountValues=event.detail.draftValues;
    console.log('Changed Data ',updateAccountValues);
    try{

      await updateAccount({
        //this  parameter must be same as in apex controller
        accounts:updateAccountValues
      })
      //making the draft values as empty
      this.draftValues=[];
      //updating wired result
      await refreshApex(this.wiredResult);
      console.log('Data updated Succesfully');
      this.showToastMessage('Success','Your Changes are Saved','success')
    }
    catch(error){
      console.error('Error Occured ',error);
      this.showToastMessage('Error','Error Occured During the Updation','error');
    }
 }
 //mapping the picklist values to every row
get accountDataWithOptions() {
    // Account data has not arrived yet
    if (!this.accountData) {
        return [];
    }
    return this.accountData.map(account => {
        return {
            ...account,
            industryValues: this.industryOptions
        };
    });
}

showToastMessage(title,message,variant){
  const showToast =new ShowToastEvent({
    title:title,
    message:message,
    variant:variant
  })
  this.dispatchEvent(showToast);
}

}