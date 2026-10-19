import { LightningElement } from 'lwc';

export default class ToDoListComponent extends LightningElement {
    tasks=[
        {Id:1,Label:'Learn Apex',Completed:false},
        {Id:2,Label:'Learn LWC',Completed:false},
        {Id:3,Label:'Learn SOQL',Completed:false}
    ]

}