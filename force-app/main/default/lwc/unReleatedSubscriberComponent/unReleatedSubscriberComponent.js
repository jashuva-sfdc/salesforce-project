import { MessageContext, subscribe } from 'lightning/messageService';
import { LightningElement,wire } from 'lwc';
import MessageChannel from '@salesforce/messageChannel/unReleatedMessageChannel__c'
export default class UnReleatedSubscriberComponent extends LightningElement {
    FullName;
    Phone;

    connectedCallback(){
        this.handleSubscribe();
    }

    @wire(MessageContext)
    messageContext
    handleSubscribe(){
        subscribe(this.messageContext,MessageChannel,
            (message)=>{
                this.FullName=message.FullName,
                this.Phone=message.Phone
            }
        )
    }
}