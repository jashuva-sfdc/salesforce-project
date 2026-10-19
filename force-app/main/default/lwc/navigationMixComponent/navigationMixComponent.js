import { LightningElement,api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
export default class NavigationMixComponent extends NavigationMixin(LightningElement) {

    @api recordId;

    handleNewButton(event){
        event.preventDefault();
        console.log('Record ID :',recordId);

        this[NavigationMixin.Navigate]({
            type:"standard__recordPage",
            attributes:{
                actionName:"view",
                recordId:this.recordId,
                objectApiName:"Position__c"
            }
        })
    }

}