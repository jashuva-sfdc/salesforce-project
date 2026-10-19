import { LightningElement,wire,api } from 'lwc';
import {getFieldValue, getRecord} from 'lightning/uiRecordApi';
import Name_Field from '@salesforce/schema/Lead.Name';
import Phone_Field from '@salesforce/schema/Lead.Phone';


const randomFields=[Name_Field,Phone_Field];
export default class LdsGetRecords extends LightningElement {

    @api recordId;
    
    leadName;//Getting the values this is one way another way is also possible getRecord
    leadPhoe;//Other way we can use getFieldValues()
    leadDetails;
    @wire(getRecord,
        {
            recordId:'$recordId',
            fields:randomFields
        }
    )
    wiredLeadRecord({error,data}){
        if(data){
            console.log('Name  Is: '+data.fields.Name.value)
            console.log('Phoen Number : '+data.fields.Phone.value)
          // this.leadName=data.fields.Name.value;
          // this.leadPhoe=data.fields.Phone.value;
          this.leadDetails=data;
        }else if(error){
            console.error('Error Message : '+error);
        }
    }
    get name(){
        if(this.leadDetails) //this.leadDetails === data
        return getFieldValue(this.leadDetails,Name_Field);
    }
    get phone(){
       if(this.leadDetails) //this.leadDetails === data
        return getFieldValue(this.leadDetails,Phone_Field);
    }
    
}