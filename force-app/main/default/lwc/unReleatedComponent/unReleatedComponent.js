import { MessageContext, publish } from 'lightning/messageService';
import { LightningElement, wire } from 'lwc';
import MessageChannel from '@salesforce/messageChannel/unReleatedMessageChannel__c';
export default class UnReleatedComponent extends LightningElement {
    FullName;
    Phone;

    handleOnChange(event){
        const name=event.target.name;
        if(name =='fullName'){
            this.FullName=event.target.value;
            console.log('Full Name',this.FullName)
        }else if(name =='phone'){
            this.Phone=event.target.value;
            console.log('Phone Number',this.Phone)
        }
    }
    @wire(MessageContext)
    messageContext
    handleClick(){
        console.log('Button Click');
        publish(this.messageContext,MessageChannel,
            {
                fullName:this.FullName,
                phone:this.Phone
            }
        )
        console.log('Data Published');
    }
}