import { LightningElement,wire } from 'lwc';
import{publish,MessageContext} from 'lightning/messageService';
import Account_Publisher from '@salesforce/messageChannel/AccountDetailsChannel__c';
export default class AccountPublisher extends LightningElement {

   //creating message context
    @wire(MessageContext)
    messageContext;

    handleButtonClick(){
        let sendData ={
            Name:'Jashuva',
            Age:25,
            Phone:'6281840543'
        }
       publish(this.messageContext,Account_Publisher,sendData)
       
    }
}