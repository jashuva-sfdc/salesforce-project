import { createRecord } from 'lightning/uiRecordApi';
import { LightningElement } from 'lwc';
import Contact_Object from '@salesforce/schema/Contact';
export default class LdsContactWithAccount extends LightningElement {
    contactInput={}

    handleContactInput(event){
        let nameField=event.target.name;
        let valueField=event.target.value;
        this.contactInput[nameField]=valueField;
    }
    handleAccountChange(event){
        let accountId=event.detail.recordId

        // Lookup field API Name
        this.contactInput.AccountId =accountId
        console.log('Selected Account Id:', accountId);
    }
       
    handleClick(){
        let fields =this.contactInput;
        const contactFields={
            apiName:Contact_Object.objectApiName,
            fields
        }
        onsole.log('After button click');
        createRecord(contactFields)
        .then((result)=>{
            let recordId=result.id;
            console.log('Contact Record Id ',recordId);
        })
        .catch((error)=>{
            console.error('Error Message',error);
        })
    }
}