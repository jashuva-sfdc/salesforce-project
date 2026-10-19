import { LightningElement, track, wire } from 'lwc';
import Candiate_Details from '@salesforce/apex/CandidateHandler.getCandidates';

const cols=[
    {label:'First Name',fieldName:'Name',type:'text'},
    {label:'Last Name',fieldName:'LastName__c'},
    {label:'Email Address',fieldName:'Email_Address__c'},
    {label:'Phone Number',fieldName:'Phone_Number__c'}
]
export default class CandidateDetailsWired extends LightningElement {
     candCols=cols;
    @track candidateDetails=[];
    errors;

    @wire(Candiate_Details)
    wiredCandidateResult({error,data}){
        if(data){
            this.candidateDetails=data;
            console.log('Fetched Data ',data);
            console.log('Coulumns',JSON.stringify(this.candCols))
            console.log('Data',JSON.stringify(this.candidateDetails))
        }else if(error){
            this.errors=error;
            console.error('Error Message',error)
        }
    }
}