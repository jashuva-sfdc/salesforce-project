import { api, LightningElement, wire } from 'lwc';
import getCaseFiles from '@salesforce/apex/CaseController.getCaseFiles';
import deleteFile from '@salesforce/apex/CaseController.confirmDeletion';
import {refreshApex} from '@salesforce/apex';
import { subscribe,unSubscribe,onError } from 'lightning/empApi';
export default class CaseFileManager extends LightningElement {

    //fetch the current record id
    @api recordId

    channelName='/data/ContentDocumentLinkChangeEvent'; // TO update when the files created
    subscription={};
    //To store ContentDoucment Link Files 
    caseFiles =[];
    WiredResult; //To refresh the Wired Data
    selectedFileIds=[] //when user is selected the duplicate file,we are storing the id here 
    selectedFileName;
    @wire(getCaseFiles,{
        caseId:'$recordId'
    })
    WiredCaseFiles(result){
        this.WiredResult=result;
        const{data,error}=result;
        if(data){
            console.log('Raw Apex Data',JSON.stringify(data));
            const files=data.map(files=>{
                return{
                    id:files.Id,
                    // this is a relationship type filed that's we are mapping
                    fileName:files.ContentDocument.Title, //file Name,
                    fileType:files.ContentDocument.FileType, //Type Of File 
                    fileSize:this.formatFileSize(files.ContentDocument.LatestPublishedVersion.ContentSize),
                    UploadedBy:files.ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                    UploadedDate:this.formatDate(files.ContentDocument.LatestPublishedVersion.CreatedDate),
                    CreatedDate: files.ContentDocument.LatestPublishedVersion.CreatedDate,
                    checksum:files.ContentDocument.LatestPublishedVersion.Checksum 

                }
            });
            //Sort files from oldest to newest
            // Earliest uploaded file will become ORIGINAL.
            // Later files with the same checksum become DUPLICATE.
            files.sort((a,b)=>{
                return new Date(a.CreatedDate) - new Date(b.CreatedDate)
            })
           this.caseFiles=this.identifyDuplicates(files);
           console.log('Case Files Data',JSON.stringify(this.caseFiles));
           console.log('Number Of Case Files',this.caseFiles.length);
         
        }
        else if(error){
            console.error('Error Occured',error);
        }
    }
 //passing the case files to chck whether having the duplicates are not
 identifyDuplicates(files){
    const originalFiles={};
    //Iterating the Case files 
     return files.map(file=>{
        //Original files is not containg any values  going to add
        if(!originalFiles[file.checksum]){
            originalFiles[file.checksum ]=file.id;
            return{
                ...file,
                id:file.id,
                isOriginal:true,
                isDuplicate:false,
                isSelected:false,
                rowClass:'original-row' //this propert used for styling purpose
            }
        }else{
            originalFiles[file.checksum]=file.id
            return{
                ...file,
                id:file.id,
                isOriginal:false,
                isDuplicate:true,
                isSelected:false,
                rowClass:'duplicate-row'
            }
        }
    });
 }

//If user is selected the duplicate record, collecting that record
 handleFileSelection(event){
    const selectedId =event.currentTarget.dataset.id;
    console.log('FROM EVENT SELECTED ID',selectedId);
    const isChecked=event.currentTarget.checked;
    console.log('CHECKED',isChecked);
    if(isChecked){
        this.selectedFileIds=[
            ...this.selectedFileIds,
                selectedId];
    }else {
        //removing the unchecked fiels from the array
        this.selectedFileIds=this.selectedFileIds.filter(fileId =>{
           return fileId !==selectedId;
        })
    }
    this.caseFiles=this.caseFiles.map(file=>{
        if(file.id ==selectedId){
            return{
                ...file,
                  isSelected:isChecked, //checking the selected id and file id both are same if same giving to the isSelected 
                  cellClass: isChecked?'selected-cell':''
            }
        }
        return file;
    });
    console.log('Selected Record Id',this.selectedFileIds);
    console.log('Number of Selected Files',this.selectedFileIds.length);
 }
 //To make the delete button as disable state,--> if the file is null then makiing as disable
 get isDeleteDisabled(){
    return this.selectedFileIds.length ==0; //if there is no selected file then we are making disbaled
 }

 isDeleteConfirmation =false 
 handleDeleteClick(){
    this.isDeleteConfirmation=true; //when the user agreed with confirmation then we are deleting the file
 }

 handleCancelDelete(){
    this.isDeleteConfirmation=false; //once the cancel is happend we are not going to display the popup
 }

 handleConfirmDelete(){
     console.log('User confirmed deletion');
     console.log('File to delete:', this.selectedFileIds);
    deleteFile({
        ContentDocumentLinkId:this.selectedFileIds
    })
    .then(()=>{
        console.log('File Deleted Successfully',this.selectedFileIds);
        this.isDeleteConfirmation=false; //once the deletion happend also we are not going to display the popup
        this.selectedFileIds=[];
        return refreshApex(this.WiredResult);
    })
    .catch(error =>{
        console.error('Error Occured During The Deletion',error);
        let message = 'File deletion failed.';

        if (error.body && error.body.message) {
            message = error.body.message;
            console.error('Actual Apex Error:', message);
        }
       
    })
 }
 connectedCallback(){
    this.handleSubscribe();
 }
 handleSubscribe(){

    subscribe(this.channelName,-1,message =>{
        console.log('Content Document Link  Received:',JSON.stringify(message));
        const changeCaseId=message.data.payload.LinkedEntityId;
        console.log('Current Case ID',this.recordId);
        console.log('Changed Case ID ',changeCaseId);
        //Chcking the current case recordId and return by the CDC is same then refresh
        if(changeCaseId == this.recordId){
            refreshApex(this.WiredResult)
            .then(()=>{
                console.log('Data Refreshed Succesfully');
            })
            .catch((error)=>{
                console.log('Error Occured During The Refresh',error);
            })
        }
     }
    )
    .then(response =>{
        console.log('Successfully Subscribed to Message Channel',response.channel);
        this.subscription=response;

    })
    .catch(error =>{
        console.log('Subscription Error',error);
    })
    
 }
  
    //Displaying the FILE Size in the Correct format
    formatFileSize(sizeInBytes) {
        if (sizeInBytes === 0) {
            return '0 Bytes';
        }
        const units = ['Bytes', 'KB', 'MB', 'GB'];
        const unitIndex = Math.floor(
                            Math.log(sizeInBytes) / Math.log(1024)
                            );
        const size = sizeInBytes / Math.pow(1024, unitIndex);
            return `${size.toFixed(2)} ${units[unitIndex]}`;
    }
    //Same Changing the Date time 
    formatDate(dateValue) {
    const date = new Date(dateValue);
        return new Intl.DateTimeFormat('en-IN', {
            day: '2-digit',
            month: 'short',
            year: 'numeric'
        }).format(date);
    }
}