import { LightningElement, wire } from 'lwc';
import contactDetails from '@salesforce/apex/ContactHandler.getContactDetails';
import {refreshApex} from '@salesforce/apex'; 
import {NavigationMixin} from 'lightning/navigation'; 
export default class ContactComponent extends NavigationMixin(LightningElement) {

    contactCols=[
        {label:'First Name',fieldName:'FirstName'},
        {label:'Last Name',fieldName:'LastName'},
        {label:'Phone',fieldName:'Phone'},
        {
            label:'Account Name',
            type:'button',
            typeAttributes:{
                label:{
                    fieldName:'AccountName'
                },
                name:'AccName'
            }
        }
    ]

    contactInfo;
    wiredContactResult
    isLoading =true;
    @wire(contactDetails)   
    wiredContact(result){
        this.wiredContactResult=result
        const {error,data} =result
        if(data){
            this.contactInfo =data.map(contact=>{
                return {
                    ...contact,
                    AccountName:contact.Account?contact.Account.Name:'' 
                }
            });
            this.isLoading=false;
            console.log('Contact Details',data)
        }else if(error){
            this.isLoading=false;
            console.log('Error Message',error)
        }
    }
    
    handleRefreshClick(){
         console.log('Data Refreshed');
        refreshApex(this.wiredContactResult)
        .then(()=>{
            console.log('Data is Refreshing ');
            this.isLoading=false;
        })
        .catch((error)=>{
            console.log('Error Occured',error)
        })
        .finally(()=>{
            this.isLoading=false;
        })
       

    }
    handleRowAction(event){
        console.log('Inside the Row Action');
        //action name is for checking on which record field 
        //In our use case Based On Account Name Navigating to different page
        const actionName=event.detail.action.name
        console.log('Action Name',actionName)
        const row=event.detail.row;
        console.log('SELECTED Row is',row.Id);
        this.navigateToAccountRecord(row.Id)
    }
    navigateToAccountRecord(recordId){
        console.log('Navigating To Record',recordId);
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:recordId,
                objectApiName:'Contact',
                actionName:'view'
            }
        })
    }
}