import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';
import Name_field from '@salesforce/schema/Patient__c.Name';
import Age_field from '@salesforce/schema/Patient__c.Age__c';
import Email_Address from '@salesforce/schema/Patient__c.Email_Address__c';
import Gender_Field from '@salesforce/schema/Patient__c.Gender__c'


const fields =[
    Name_field,
    Age_field,Email_Address,Gender_Field
]
export default class PatientDetails extends LightningElement {
    @api patientId;
    
      patientName;
      patientAge;
      patientGender;
      emailAddress;
    @wire(getRecord,{
       recordId:'$patientId',
       fields: fields
    })
    wiredPatientResult(result){
        console.log('Child Component Statred');
        console.log('Wired result',result);
        const {error,data}=result
        if(data){
            this.patientName=getFieldValue(data,Name_field);
            this.patientAge=getFieldValue(data,Age_field);
            this.patientGender=getFieldValue(data,Gender_Field);
            this.emailAddress=getFieldValue(data,Email_Address);
            console.log('Name',this.patientName);
            console.log('Email Address',this.emailAddress);
        }else if(error){
            console.error('Error Occured',error);
        }
    }
}