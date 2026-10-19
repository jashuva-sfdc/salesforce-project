import { LightningElement,wire } from 'lwc';
import getAccount from '@salesforce/apex/WiredCotroller.fetchAccounts';
import getContacts from '@salesforce/apex/WiredCotroller.fetchContacts';
import getOpportunity from '@salesforce/apex/WiredCotroller.fetchOpportunities'
export default class ControllingTheWireExecution extends LightningElement {

    accCols=[
        {label:'Name',fieldName:'Name'},
        {label:'Industry',fieldName:'Industry'},
        {label:'Phone',fieldName:'Phone'},
        {label:'Rating',fieldName:'Rating'}
    ];
  conCols=[
     {label:'First Name',fieldName:'FirstName'},
     {label:'Last Name',fieldName:'LastName'},
     {label:'Email Address',fieldName:'Email'}
  ]
  oppCols=[
    {label:'Opportunity Name',fieldName:'Name'},
    {label:'Stage Name',fieldName:'Stage'}
  ]
    contactExecuted=false;
    opportunityExecuted =false;
    accountsData=[];
    contactsData=[];
    opportunityData=[];
    accountId;
    @wire(getAccount)
    WiredAccountData({error,data}){
     console.log('Account Wired Executed');
        if(data){
            this.accountsData = data;
            this.contactExecuted=true;
            console.log('Data is :',data);
            if(data.length > 0){
                this.accountId=data[0].Id;
            }
        }
        else if(error){
            this.accountsData = error;
            console.error('Error Message',error);
        }
    }
    @wire(getContacts,{execute:'$contactExecuted'})
    WiredContactData({error,data}){
        console.log('Contact Wired Executed');
        if(data && this.contactExecuted){
            this.accountsData = data;
            this.opportunityExecuted=true;
            console.log('Data is :',data);
        }
        else if(error){
            this.accountsData = error;
            console.error('Error Message',error);
        }
    }
    @wire(getOpportunity,{execute:'$opportunityExecuted'})
    WiredOpportunityData({error,data}){
       console.log('Opportunity Wired Executed');
        if(data && this.opportunityExecuted){
            this.opportuniytData = data;
            this.opportunityExecuted=true;
            console.log('Data is :',data);
        }
        if(error){
            this.accountsData = error;
            console.error('Error Message',error);
        }
    }
}