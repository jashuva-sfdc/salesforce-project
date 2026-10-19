import { LightningElement, track, wire } from 'lwc';
import Account_Details from '@salesforce/apex/AccountHandler.getAccountRecords';
import { MessageContext, publish } from 'lightning/messageService';
import Account_Channel from '@salesforce/messageChannel/AccountListDetailsChannel__c'
export default class AccountList extends LightningElement {

    @track accountOptions=[];
    selectedAccRecord;
    errorMessage;

   
    @wire(Account_Details)
    wiredAccount({data,error}){
        if(data){
            this.accountOptions=data.map((record)=>{
               return{
                    label:record.Name,
                    value:record.Id
               } 
            })
            console.log('Data FROM Apex Controller',this.accountOptions)
        }else if(error){
            this.errorMessage=error;
        }
    }
    @wire(MessageContext)
    messageContext;
     handleChange(event){
        this.selectedAccRecord=event.detail.value;
        console.log('Selected Record',this.selectedAccRecord);

        publish(this.messageContext,Account_Channel,{
            selectedAccRecord:this.selectedAccRecord
        });
    }

}