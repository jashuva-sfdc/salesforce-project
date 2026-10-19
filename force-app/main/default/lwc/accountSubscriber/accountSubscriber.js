import { LightningElement } from 'lwc';
import { subscribe,createMessageContext,releaseMessageContext } from 'lightning/messageService';
import Account_Subscribe from '@salesforce/messageChannel/AccountDetailsChannel__c';
export default class AccountSubscriber extends LightningElement {

    messageContext=createMessageContext();
    name='';
    phone='';
    age=''
     connectedCallback(){
        this.handleSubscribe();
     }
     handleSubscribe(){
        subscribe(this.messageContext,Account_Subscribe,
           (message)=> {
                this.name=message.Name,
                this.phone=message.Phone,
                this.age=message.Age
            }
        )
     }
     disconnectedCallback(){
        this.messageContext=releaseMessageContext();
     }
}