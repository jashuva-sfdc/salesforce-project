import { api, LightningElement, wire } from 'lwc';
import getServiceFiles from '@salesforce/apex/ServiceRequestController.getServiceFiles';
import {refreshApex} from'@salesforce/apex';
import deleteRequestFiles from '@salesforce/apex/ServiceRequestController.deleteAllFiles'
export default class ServiceRequestFileManager extends LightningElement {
    @api recordId;

    serviceRequestFiles =[];
    wiredResult;
    @wire(getServiceFiles,{
        serviceRequestId:'$recordId'
    })
    WiredFilesResult(result){
        this.wiredResult=result;
        const{data,error}=result;
        if(data){
            const serviceFiles=data.map(files => {
                return {
                    id:files.Id,
                    fileName:files.ContentDocument.Title,
                    fileType:files.ContentDocument.FileType,
                    fileSize:files.ContentDocument.LatestPublishedVersion.ContentSize,
                    uploadedName:files.ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                    uploadedDate:files.ContentDocument.LatestPublishedVersion.CreatedDate,
                    checksum :files.ContentDocument.LatestPublishedVersion.Checksum
                };
            });
            serviceFiles.sort((a,b)=>{
                return new Date (a.uploadedDate) - new Date(b.uploadedDate);
            })
            this.serviceRequestFiles=this.identifyDuplicateFiles(serviceFiles);;
            console.log('Service Request Files',JSON.stringify(this.serviceRequestFiles));
            console.log('Total Service Request Files',this.serviceRequestFiles.length);
        }else if(error){
            console.error('ERROR Message',error);
        }
    }
    identifyDuplicateFiles(serviceFiles){
        console.log('INSIDE THE DUPLICATION IDENTIFIER FILES');
        const originalFiles={}
        return serviceFiles.map(file =>{
            if(!originalFiles[file.checksum]){
                originalFiles[file.checksum]=file.id
                return{
                    ...file, ////keep the existing file
                    id:file.id,
                    isOriginal:true,
                    isDuplicate:false,
                    isSelected:false,
                    rowClass:'original-row'
                }
            }else{
                return{
                    ...file, //keep the existing file
                    id:file.id,
                    isOriginal:false,
                    isDuplicate:true,
                    isSelected:false,
                    rowClass:'duplicate-row'
                }
            }
        });
    }
    selectedFileIds=[];
    handleOnChange(event){
        const selectedId=event.currentTarget.dataset.id;
        console.log('SELECTED FILE ID',selectedId);
        const isChecked=event.currentTarget.checked;
        console.log('CHECKED',isChecked);
        if(isChecked){
            //add the selected files
            this.selectedFileIds=[
                ...this.selectedFileIds,
                selectedId
            ]
        }
        else {
            //if user is unselecting the files then removing those id's
            this.selectedFileIds=this.selectedFileIds.filter(fileId =>{
                return fileId !=selectedId
            })
        }
        this.serviceRequestFiles =this.serviceRequestFiles.map(serviceFile =>{
          //To check whether the current file id and selected file id both are matched or not  
            if(serviceFile.id === selectedId){
                return {
                    //if same keep the file 
                    ...serviceFile,
                    isSelected:isChecked,
                    cellClass:isChecked ? 'selected-cell':'' //this is for styling to highlight the selected rows

                }
            }
            return serviceFile;
        })
         console.log('Selected Ids ',JSON.stringify(this.selectedFileIds));
         console.log('Number of Selected ids ',this.selectedFileIds.length);

    } 
    get isDeleteDisabled(){
        return this.selectedFileIds.length ==0;
    }
    isDeleteConfiramtion =false;
    handleOnDeleteClick(){
        this.isDeleteConfiramtion=true;
        console.log('Asking for Deletion Confirmation',this.isDeleteConfiramtion);
    }  
    handleCancelDelete(){
        this.isDeleteConfiramtion=false;
        console.log('Customer Selected the cancel ',this.isDeleteConfiramtion);
    } 
    //If user agreed to confirm the deletion then we will 
    handleConfirmDelete(){
        console.log('User confirmed the deletion');
        deleteRequestFiles({
            contentDocumentId:this.selectedFileIds
        })
        .then(()=>{
            this.selectedFileIds=[];
            this.isDeleteConfiramtion=false;
             console.log('File Ids Deleted Sucessfully',this.selectedFileIds);
           return  refreshApex(this.wiredResult);
        })
        .error((error)=>{
            console.error('Error Occured in Imperative ',error);
        })
    }

    
}