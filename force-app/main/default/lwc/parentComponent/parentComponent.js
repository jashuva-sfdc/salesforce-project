import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
  //this all the code will be considered as Parent To Child Component
    patientName;
    patientAge;
    patientGender;
    showData =false;
    handleOnChange(event){
        const name=event.target.name;
        if(name =='pName'){
            this.patientName=event.target.value;
        }else if(name =='pAge'){
            this.patientAge=event.target.value;
        }else if(name == 'pGender'){
            this.patientGender =event.target.value;
        }
    }
    handleClick(){
        this.showData=true;
        const inputs=this.template.querySelectorAll('lightning-input');
        inputs.forEach(input => {
            input.value=''
        });
    }
//Child TO Parent Component
//child is sending the parent here listening the data 
childStatus;
handleChildData(event){
    this.childStatus=event.detail;
}
}