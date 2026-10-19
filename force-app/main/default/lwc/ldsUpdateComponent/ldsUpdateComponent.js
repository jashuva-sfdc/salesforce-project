import { api, LightningElement } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LdsUpdateComponent extends LightningElement {
 @api recordId;
 
 candiToUpdateFields={};

 handleUpdateInput(event){
    let {name,value}=event.target;
    this.candiToUpdateFields[name]=value;
 }
    handleClick(){
        console.log('Button click fired')
         console.log('recordId value is:', this.recordId);
         console.log('Type of recordId:', typeof this.recordId);
        console.log(JSON.stringify(this.candiToUpdateFields));
        let fields=this.candiToUpdateFields;
        fields.Id=this.recordId;
        const updateFileds={
            fields:fields
        }
        console.log(JSON.stringify(fields));
        console.log(this.recordId);

        console.log('Before Update Record');
        updateRecord(updateFileds)
        .then((result)=>{
             console.log(' After Updated Record');
            console.log('Succesfull Message :'+JSON.stringify(result));
            const toastMessage= new ShowToastEvent(
                {
                        title: 'Success',
                        message: 'Candidate Updated Successfully',
                        variant: 'success'
                })
                this.dispatchEvent(toastMessage);
        })
        .catch((error)=>{
             const toastMessage= new ShowToastEvent(
                {
                        title: 'Error',
                        message:error.body.message,
                        variant: 'error'
                })
                this.dispatchEvent(toastMessage);
            console.error('Error Message :'+JSON.stringify(error));
        })
    }
}