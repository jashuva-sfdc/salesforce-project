import { MessageContext, publish } from 'lightning/messageService';
import { LightningElement,wire } from 'lwc';
import hospitalMessageChannel from '@salesforce/messageChannel/hospitalMessageChannel__c';
export default class PatientPublisher extends LightningElement {
    hospitalName;

    handleOnChange(event){
        this.hospitalName=event.target.value;
    }
    @wire(MessageContext)
    messageContext
    handleClick(){
        console.log('Button Clicked In Publisher Component');
        console.log('Hospital Name',this.hospitalName);
        try{
            publish(this.messageContext,hospitalMessageChannel,
            {
            message:this.hospitalName
            })
         console.log('Message Published')
        }
        catch(error){
            console.error('Error Message',error);
        }

    }
        
 }