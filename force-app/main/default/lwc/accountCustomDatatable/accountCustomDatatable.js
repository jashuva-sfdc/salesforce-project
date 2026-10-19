import { LightningElement, wire } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import getAccounts from '@salesforce/apex/AccountController.getAccountDetails';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class AccountCustomDatatable extends LightningElement {
    cols=[
        {label:'Account Name',fieldName:'Name',type:'text'},
        {label:'Phone',fieldName:'Phone',type:'phone'},
        {label:'Annual Revenue',fieldName:'AnnualRevenue',type:'currency',
            cellAttributes:{
                alignment:'left'
            }
        },
        {label:'Industry',fieldName:'Industry'},
        {label:'Action', type:'button',
            typeAttributes:{
                label:'Edit', //label name 
                name:'edit', //To identifying the clicked action
                //when we placed the cursor then it will populates this value like hover type
                title:'Edit Account',
                variant:'neutral'
            }
        }
    ]
    accountData;
    wiredResult; //To Refresh the wired data when the updates happens
    selectedRecordId; //To store the record Id when user clicks the edit button
    isEditOpenForm =false; //intially we don't want to open the record form,when the user click button  
    @wire(getAccounts)
    WiredAccounts(result){
        this.wiredResult=result;
        const{data,error}=result;
        if(data){
            this.accountData=data;
        }else if(error){
            console.log('Error Occured ',error);
        }
    }
    
    handleEditButton(event){
        console.log('FULL ACTION',JSON.stringify(event.detail.action.name));
        console.log('Row',event.detail.row);
        console.log('Record Id',event.detail.row.Id);
        this.actionName =event.detail.action.name;
        this.selectedRecordId=event.detail.row.Id;
        console.log('SELECTED RECORD ID IS : ',this.selectedRecordId);
        //here we are making variable as TRUE,BCZ to show the form upon clicking the button else it 
        //won't populates the edit form 
        this.isEditOpenForm =true;
    }

    //handle cancel button --> when the form level if the user is selected as cancel 
    //we have to disappear the form
    handleCancel(){
        console.log('Edit Canceled');
        this.isEditOpenForm=false; //closing the form / modal
        //Removing selected id
        this.selectedRecordId=null;
    }
    
   async handleSave(event){
        console.log('Account Updated Successfully',event.detail.Id);
        //Closing the EDIT FORM
        this.isEditOpenForm=false;

        //and updating the wired data 
     await refreshApex(this.wiredResult);
     this.handleShowToastNotification('Success','Your Changes are Saved','success')
    }

    handleShowToastNotification(title,message,variant){
        const dispatchToast =new ShowToastEvent({
                                title:title,
                                message:message,
                                variant:variant
                             });
            this.dispatchEvent(dispatchToast);
    }
}