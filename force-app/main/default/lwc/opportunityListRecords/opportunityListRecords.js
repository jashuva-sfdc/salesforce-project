import { LightningElement, wire } from 'lwc';
import Opporutnity_List from '@salesforce/apex/OpportunityHandler.opportunityList';
import { publish,MessageContext } from 'lightning/messageService';
import Opportunity_Channel from '@salesforce/messageChannel/OpportunityBridge__c';
export default class OpportunityListRecords extends LightningElement {

    options=[];
    selectedRecord;
    errorMessage='';

    @wire(Opporutnity_List)
    wiredOpportunityList({data,error}){
        if(data){
            this.options=data.map(record=>{
                return{
                    label:record.Name,
                    value:record.Id
                };
            });
            console.log(JSON.stringify(this.options));
        }else if(error){
            this.errorMessage=error;
            console.error('Error Message',this.errorMessage);
        }
    }
    @wire(MessageContext)
    messageContext;
    handleChange(event){
        console.log('Selected Record',event.detail.value);
        this.selectedRecord=event.detail.value;
       // console.log('Selected Record',this.selectedRecord);
       
    publish(this.messageContext,Opportunity_Channel,{
        selectedRecord:this.selectedRecord
    });
   }

}