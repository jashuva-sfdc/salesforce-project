import { api, LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
  //Parent is sending the data child is listening 
    @api patientName;
    @api patientAge;
    @api patientGender;
//child here sending the parent is accetptinng the Data 
status='';
handleOnChange(event){
    const value=event.target.value;
    this.status=value;
}
handleOnClick(){
    const sendData=new CustomEvent('senddata',{
        detail:this.status
    })
    this.dispatchEvent(sendData);
}
}