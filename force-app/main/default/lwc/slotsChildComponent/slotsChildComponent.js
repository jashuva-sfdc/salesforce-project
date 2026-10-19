import { LightningElement } from 'lwc';

export default class SlotsChildComponent extends LightningElement {
 renderedCallback(){
    const slots =this.template.querySelector('slot');
    const elements=slots.assignedElements;
    console.log('Slot Values ',elements);

 }  
}