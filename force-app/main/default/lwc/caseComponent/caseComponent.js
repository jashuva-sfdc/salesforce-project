import { LightningElement,api } from 'lwc';
import STATUS_Field from '@salesforce/schema/Case.Status';
import Account_Field from '@salesforce/schema/Case.AccountId';
import Contact_Field from '@salesforce/schema/Case.ContactId';
import Description_Field from '@salesforce/schema/Case.Description';
import CaseNumber_Field from '@salesforce/schema/Case.CaseNumber';
export default class CaseComponent extends LightningElement {
    fields=[
        {objectApiName:'Case', fieldApiName:'Priority'},
        STATUS_Field,
        Account_Field,
        Contact_Field,
        Description_Field,
        CaseNumber_Field
    ]
  
    
}