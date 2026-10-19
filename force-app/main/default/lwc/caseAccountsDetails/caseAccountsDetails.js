import { LightningElement, wire } from 'lwc';
import getCaseDetails from '@salesforce/apex/CaseController.casesWithAccounts';
import{ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';
export default class CaseAccountsDetails extends LightningElement {

    cols=[
        {label:'Case Number',fieldName:'CaseNumber'},
        {label:'Case Status',fieldName:'Status'},
        {label:'Case Origin',fieldName:'Origin'},
        {
            label:'Account Name', type:'text',
            fieldName:'AccountName',
            name:'AccounDetails',
            variant:'base'
        }
    ]

    caseDetails;
    //To store the wired result we are using this below variable and to refresh the data
    wiredResult;

    @wire(getCaseDetails)
    WiredCases(result){
        this.wiredResult=result;
        const{error,data}=result
        if(data){
            this.caseDetails = data.map(caseinfo =>{
                return{
                    ...caseinfo,
                    AccountName:caseinfo.Account?caseinfo.Account.Name:''
                }
            });
            console.log('Case Details Are ',this.data);
        }else if(error){
            console.error(error);
        }
    }
    handleShowToast(title,message,variant){
       const toast= new ShowToastEvent({
            title:title,
            message:message,
            variant:variant
        })
        this.dispatchEvent(toast);
    }
    handleClickRefresh(){
        console.log('Refresh Button Clicked');
        refreshApex(this.wiredResult)
        .then(()=>{
            this.handleShowToast('Success','Case Data Refrshed','success');
        })
        .error(error =>{
            this.handleShowToast('Error Message','Error Occured During Refresh','error');
            console.error('Error Message',error);
        })
    }
}