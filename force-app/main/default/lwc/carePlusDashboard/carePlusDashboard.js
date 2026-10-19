import { LightningElement, wire } from 'lwc';
import carePlusData from '@salesforce/apex/DashboardController.getAllDetails';
import getLatestAppointments from '@salesforce/apex/DashboardController.getLatestAppointments';
import searchPatientData from'@salesforce/apex/DashboardController.searchPatients';
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
export default class CarePlusDashboard extends NavigationMixin (LightningElement) {
    
  
    totalPatinetsCount=0;
    totalDoctorsCount=0;
    todayAppointmentCount=0;
    pendingBillsCount=0;
    totalRevenueSum=0;

    dashboardData;
    latestAppointments=[];
    //to show the spinner loading type on UI level when data is refreshed
    isLoading=false;
 @wire(carePlusData)
 WiredCarePlusMethod(result){
    this.dashboardData=result;
    const{data,error}=result;
    if(data){
    this.totalPatinetsCount =data.totalPatients;
    this.totalDoctorsCount=data.totalDoctors;
    this.todayAppointmentCount=data.todayAppointments;
    this.pendingBillsCount =data.pendingBills;
    this.totalRevenueSum=data.totalRevenue;

    console.log('Dashboard Data',data);
   }else if(error){
    console.error('Error Message ',error);
     this.showToast(
      'Dashboard Error',
      'Unable to Load the Dashboard Data',
      'error'
     )
   }
 }
 //create a method to show the toast messages
 showToast(title,message,variant){
    const event=new ShowToastEvent({
              title:title,
              message:message,
              variant:variant
            })
      this.dispatchEvent(event);
 }

//upon click the button REFRESH then fetching the current data 
 handleRefreshDashboard(){
  console.log('Refreshing The Dashboard');
  console.log('Wired Result :',this.dashboardData);
  console.log('Type Of Refresh Apex',typeof refreshApex)
  
  this.isLoading=true; //data is loading

  try{  

     refreshApex(this.dashboardData)
    .then(()=>{
      console.log('Dashboard Refreshed Successfully');
      this.isLoading=false //once data fetched then making disapper 
      this.showToast('Success','Dashboard Refreshed Successfully','success')
    })
    .catch(error =>{
      console.log('Error ',error);
    })
    .finally(()=>{
      this.isLoading=false // If error came then making disapper
    })
  }catch(error){
        console.error('Synchronous Refresh Error:', error);
        this.isLoading = false;
  }

 }

      cols=[
        {
          label:'Appointment Date',
          fieldName:'Appointment_Date__c'
        },
        {
          label:'Appointment ID',type:'button',
          typeAttributes:{
            label:{
              fieldName:'Name'
            },
            name:'appointmentId', variant:'base'
            }
        },
        {
          label:'Patient Name',type:'button',
          typeAttributes:{
            label:{
              fieldName:'patientName'
            },
            name:'patient',variant:'base'
          }
        },
        {
          label:'Doctor Name', type:'button',
          typeAttributes:{
            label:{
              fieldName:'doctorName'
            },
            name:'doctor',variant:'base'
          }
        },
        {
          label:'Status ',
          fieldName:'Status__c',
           
        }
      ];
      
      @wire(getLatestAppointments)
      WiredGetLatestApppointments(result){
        const{error,data}=result;
        console.log('Inside The Wired Method First');
        if(data){
          //If you want to fetch the relationship field values we have to map those values
          //Bcz relationship fields doesn't works directly
          this.latestAppointments=data.map(appointment=>{
            return{
                ...appointment,
                appointmentName:appointment.Name,
                //patient name Using Teranary Operator bcz the parent records
                patientName:appointment.Patient__r?appointment.Patient__r.Name:'',
                //Doctor Name
                doctorName:appointment.Doctor__r?appointment.Doctor__r.Name:''
            }
            
          })
          console.log('Latest Appintment Details ',this.latestAppointments);   
          this.showToast('Success','Successfully Fetched Latest Appointments','success');

        }else if(error){
          console.error('Error Message:',error);
          this.showToast('Error Message ','Not Able To Get The Latest Appointment','error');
        }
      }

      handleRowAction(event){
        const actionName=event.detail.action.name;

        const row=event.detail.row;
        if(actionName =='appointmentId'){
          this.navigateToRecord(row.Id);
        }
        else if(actionName == 'patient')
        {
          this.navigateToRecord(row.Patient__c);
        }
        else if(actionName =='doctor')
        {
          this.navigateToRecord(row.Doctor__c);
        }
      }
      navigateToRecord(recordId){
        console.log('Navigating To Record',recordId);
        this[NavigationMixin.Navigate]({
          type:'standard__recordPage',
          attributes:{
            recordId:recordId,
            actionName:'view'
          }
        })
      }


      //searching the patients based on names
      patientCols=[
        {label:'Name',fieldName:'Name',
          type:'button',
          typeAttributes:{
            label:{
              fieldName:'Name'
            },
            name:'viewPatient',
            variant:'base'
          }
        },
        {label:'Age',fieldName:'Age__c'},
        {label:'Email Address',fieldName:'Email_Address__c'},
        {label:'Gender', fieldName:'Gender__c'}
      ]
      patientName;//user input
      patientDetails=[]; //data from apex controller
      selectedPatientId; //sending the data from parent to child
       //If there are no records will displays the data
      handlePatientOnChange(event){
        const pName=event.target.value;
        this.patientName=pName;
        console.log('Patient Name ',this.patientName);
      }
      //imperative method and while passing the parameters input values should be same in apex controller and imperative also
      handlePatientSearch(){
        searchPatientData({patientName:this.patientName })
        .then(data=>{
          this.patientDetails=data;
          if(data.length >0){
             this.showToast(
              'Success',
              `'Record Fetched Succesfully' ${this.patientName}`,
              'success');
          }else {
            this.showToast(
                'Info',
                `No patient found for ${this.patientName}`,
                'info')
           console.log('Patient Details',this.patientDetails);
            }
        })
        .catch(error =>{
          console.error('Error Message',error)
          this.showToast('Error Message','Record Not Found','error');
        })
      }
      handlePatientRowSelection(event){
    console.log('===== ROW SELECTION START =====');
    console.log('Event:', event);
    console.log('Event Detail:', event.detail);
    console.log('Selected Rows:',event.detail.selectedRows);
        const selectedRows=event.detail.selectedRows;
        //selected record Id to send id to child and displaying the data 
        if(selectedRows.length >0){
           const selectedPatient=selectedRows[0];
           console.log('Selected Patient',selectedPatient);
           console.log('Selected Patient Id',selectedPatient.Id);
           this.selectedPatientId=selectedPatient.Id;
           console.log('Parent Patient Id',this.selectedPatientId)
        }
      }
      handleRowAction(event){
        const actionName=event.detail.action.name;
        const row=event.detail.row;
        if(actionName =='viewPatient'){
           this.navigateToPatientRecord(row.Id);
        }
      }
      navigateToPatientRecord(recordId){
        console.log('Navigation To Patient Record Page',recordId);
        this[NavigationMixin.Navigate]({
          type:'standard__recordPage',
          attributes:{
            recordId:recordId,
            objectApiName:'Patient__c ',
            actionName:'view'
          }
        })
      }
      //clear the search input data 
      handleClear(){
        this.patientName='';
        this.patientDetails=[];
      }
}