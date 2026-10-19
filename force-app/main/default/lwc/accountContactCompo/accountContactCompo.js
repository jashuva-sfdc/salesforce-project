import { LightningElement } from 'lwc';
import {createRecord} from 'lightning/uiRecordApi';
//object creation import
import Account_Object from '@salesforce/schema/Account';

//Contact Creation 
import Contact_Object from '@salesforce/schema/Contact';
import Contact_AccountId from'@salesforce/schema/Contact.AccountId'

export default class AccountContactCompo extends LightningElement {

    accountFileds={};
    contactFields={};

    handleAccountInput(event){
        event.preventDefault();
        let {name,value}=event.target;
        this.accountFileds[name]=value;

    }
    handleContactInput(event){
        event.preventDefault();
        let{name,value}=event.target;
        this.contactFields[name]=value;
    }
    handleClick(){
        console.log(Account_Object);
        let fields=this.accountFileds
        //Account details based on this account and fields create the records
        const accRecordFieldsId={
           apiName:Account_Object.objectApiName,
            fields
        }
        createRecord(accRecordFieldsId) //once records are created or not it will provides the either successfull or failure
        // then do creation for the contact also 
        .then((result)=>{
            console.log(JSON.stringify(result));
            if(result){
                let accId =result.id;
                this.handleCreateContact(accId);
            }
            })
        .catch((error)=>{
            console.log(JSON.stringify(error));
        })    
    }
    handleCreateContact(accId){
        
        let fields =this.contactFields;
        //Get the Account  Id and giving to the Contact ACCOUNTID field
        fields[Contact_AccountId.fieldApiName]=accId
        const contactFields ={
            //This is object 
            apiName:Contact_Object.objectApiName,
            //and this is for fields 
            fields
        }
        createRecord(contactFields)
        .then((result)=>{
            let conId=result.id;
            console.log(conId);
            console.log(result);
        })
        .catch((error)=>{
            console.log(error);
        })
        this.accountFileds={};
        this.contactFields={};
    }
}