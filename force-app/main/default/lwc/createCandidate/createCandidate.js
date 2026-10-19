import {  LightningElement } from 'lwc';
import {createRecord} from'lightning/uiRecordApi';
import{ShowToastEvent} from 'lightning/platformShowToastEvent';
//create candidate record
import Candidate_Object from '@salesforce/schema/Candidate__c';
export default class CreateCandidate extends LightningElement {

 candidateFields={};
    handleCandidateInput(event){
        let {name,value}=event.target
        this.candidateFields[name]=value
        /* above line meaning 
        candidateRecord={
        name:value
        }
        */
    }
    
    handleClick(){
        console.log('Candidate details'+JSON.stringify(this.candidateFields));
        let fields =this.candidateFields;
        //Fetching the fields with object to create 
        const candidateRecords={
            apiName:Candidate_Object.objectApiName,
            fields
        }
    createRecord(candidateRecords)
        .then((result)=>{
            console.log(result)
            if(result){
                let recordId=result.id;
                console.log(recordId);
                console.log('Success'+JSON.stringify(result));
            }
             this.dispatchEvent(new ShowToastEvent({
                    title:'Success',
                    message:'Record Created Sucessfully',
                    variant:'success'
                }))
                //once record created successfully clearing the field values
                this.candidateFields={};
                this.template.querySelectorAll('lightning-input').forEach(input => {
                    input.value ='';
                })
        })
        .catch((error)=>{
             this.dispatchEvent(new ShowToastEvent({
                    title:'Error Message',
                    message:error.body.message,
                    variant:'error'
                }))
            console.error('Error Message'+JSON.stringify(error));
        })
    }
    
    }