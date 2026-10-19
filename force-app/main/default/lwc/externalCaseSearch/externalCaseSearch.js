import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { LightningElement, wire } from 'lwc';
import Case_Object from '@salesforce/schema/Case';
import searchCasesOrgB from '@salesforce/apex/ExteranlCaseSearchController.getCaseDetails';
export default class ExternalCaseSearch extends LightningElement {

    priorityOptions =[];
    originOptions =[];
    statusOptions =[];
    selectedPriority ='';
    selectedOrigin='';
    selectedStatus='';
    @wire(getObjectInfo,
        {objectApiName:Case_Object}
    ) objectInfo;
    @wire(getPicklistValuesByRecordType,{
        objectApiName:Case_Object,
        recordTypeId:'$objectInfo.data.defaultRecordTypeId'
    })
    caseStatusPickValue({data,error}){
        if(data){
     //getPicklistValuesByRecordType returns the picklist fields inside the "picklistFieldValues" property.
            const picklist=data.picklistFieldValues;
            this.statusOptions = picklist.Status.values;
            this.originOptions=picklist.Origin.values;
            this.priorityOptions=picklist.Priority.values;
            console.log('Case Status  Value',this.statusOptions);
            console.log('Case Priority Values',this.priorityOptioins);
            console.log('Case Origin Values',this.originOptions);
        } else if(error){
            this.statusOptions = [];
            this.priorityOptions=[];
            this.originOptions=[];
            console.error('Error Occured',error);
        }
    };
    handleOnChange(event){
        console.log('Inside the handler ',event.target.value);
        const fieldName=event.targe.name;
        console.log('Selected Field name',fieldName);
        if(fieldName ==='status'){
            this.selectedStatus=event.detail.values;
            console.log('Selected Status Is',this.selectedStatus);
        }else if(fieldName ==='priority'){
            this.selectedPriority=event.detail.value;
        }else if(fieldName ==='origin'){
            this.selectedOrigin =event.detail.value;
        }
         console.log('Status:', this.selectedStatus);
        console.log('Priority:', this.selectedPriority);
        console.log('Origin:', this.selectedOrigin);
        console.log('SELECTED ALL FIELDS ',
           JSON.stringify( {
                priority:this.selectedPriority,
                origin  :this.selectedOrigin,
                status  :this.selectedStatus
            })
            );
    }
    get isSearchDisabled(){
        return !(this.selectedStatus && this.selectedPriority && this.selectedOrigin);
    }
    handleClickSearch(){

        searchCasesOrgB({
            caseStatus:this.caseStatus,
            casePriority:this.casePriority,
            caseOrigin:this.caseOrigin
            }
        )
        .thne((result)=>{
            console.log('Data sent successfully',result);
        })
        .catch((error)=>{
            console.log('Error Occured During the Imperative',error);
        })
    }
    handleClickClear(){
        this.selectedOrigin ='';
        this.selectedPriority='';
        this.selectedStatus='';
    }
    // 
}