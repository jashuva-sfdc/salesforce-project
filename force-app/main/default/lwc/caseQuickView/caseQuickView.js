import {  getFieldDisplayValue, getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';

import SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import CASENUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';
import Case_Origin from '@salesforce/schema/Case.Origin';
import Case_Status from '@salesforce/schema/Case.Status';
const FIELDS =[SUBJECT_FIELD,CASENUMBER_FIELD];
export default class CaseQuickView extends LightningElement {

    @api recordId;

    @wire(getRecord,{
        recordId:'$recordId',
        fields:[SUBJECT_FIELD,CASENUMBER_FIELD,Case_Origin]
    })
    caseRecord //this will holds the data coming from wire adaptor
    get subject(){
        return this.caseRecord.data ? getFieldValue(this.caseRecord.data,SUBJECT_FIELD):'';
    }
    get caseNumber(){
        return this.caseRecord.data ? getFieldValue(this.caseRecord.data,CASENUMBER_FIELD):'';
    } 
    get caseOriginRaw(){
        return this.caseRecord.data ?getFieldValue(this.caseRecord.data,Case_Origin):'';
    }
    get caseStatus(){
        return this.caseRecord.data ? getFieldValue(this.caseRecord.data,Case_Status):'';
    }
    
    /*second way to handle the data without using getters
    CaseNumber;
    CaseSubject;
    caseData;
    @wire(getRecord,{
        recordId:'$recordId',
        fields:FIELDS
    })
    WiredRecords({data,error}){
        if(data){
            this.caseData=data;
            this.CaseNumber=this.caseData.fields.CaseNumber.value;
            this.CaseSubject=this.caseData.fields.Subject.value;
            console.log('Case Number',this.CaseNumber);
            console.log('Case Subject',this.CaseSubject);
        }else if(error){
            console.error('Error Occured',error);
        }
    }
    */

}