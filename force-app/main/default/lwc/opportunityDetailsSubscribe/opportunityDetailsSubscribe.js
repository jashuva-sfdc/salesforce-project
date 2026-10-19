import { LightningElement,wire } from 'lwc';
import { subscribe,MessageContext } from 'lightning/messageService';
//Below one is message channel 
import Opportunity_Channel from '@salesforce/messageChannel/OpportunityBridge__c';
//Apex Controller
import Opportunity_Details from '@salesforce/apex/OpportunityHandler.getAllDetails';
export default class OpportunityDetailsSubscribe extends LightningElement {
  cols =[
    {label:'Name',fieldName:'Name'},
    {label:'Stage Name',fieldName:'StageName'},
    {label:'Amount',fieldName:'Amount'}
  ];

    receivedData=[];
    errorMessage;

    @wire(MessageContext)
    messageContext
    connectedCallback(){
        this.handleSubscribe()
    }
    handleSubscribe(){
        subscribe(this.messageContext,Opportunity_Channel,(message)=>{
            console.log('Received Message',message);
            this.loadOppDeatils(message.selectedRecord);
            console.log('Subscriber Received ID',message.selectedRecord);
        })
    }
    loadOppDeatils(opportunityId){
        Opportunity_Details(
            {opportunityId:opportunityId}
        )
        .then((result)=>{
            this.receivedData=result;
            console.log('Received Data',result);
        })
        .catch((error)=>{
            this.errorMessage=error;
            console.error('Error Message',this.errorMessage);
        })
    }
}