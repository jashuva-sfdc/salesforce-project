import { MessageContext, subscribe } from 'lightning/messageService';
import { LightningElement, wire } from 'lwc';
import hospitalMessageChannel from '@salesforce/messageChannel/hospitalMessageChannel__c';

export default class PatientSubscriber extends LightningElement {
    patientResponse;
    subscription
     @wire(MessageContext)
     messageContext

    connectedCallback(){
       console.log('Inside the Connected Callback');
    }
    renderedCallback(){
        //this.messageContext ==true 
        if(this.messageContext && !this.subscription ){
            console.log('Inside The Rendered Callback');
            this.subscribeToMessageChannle();
        }
    }
   
    subscribeToMessageChannle(){
        try{
             this.subscription=subscribe(this.messageContext,hospitalMessageChannel,(response)=>{
                this.patientResponse=response.message;
                console.log('Subscription Message');
                console.log('Response :',response.message);
                console.log('Received Data',this.patientResponse);
              console.log('Subscription Object',this.subscription)  
           })
        }catch(error){
            console.error('Error Message',error);
        }    
    }
}