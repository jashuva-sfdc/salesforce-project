import { LightningElement } from 'lwc';

export default class FirstTaskComponent extends LightningElement {
   
    taskList=[];
    title ='';
    priority='';

    priorityOptions=[
        {label:'Low',value:'Low'},
        {label:'Medium',value:'Medium'},
        {label:'High',value:'High'}
    ]
    handleOnChange(event){
        event.preventDefault();
        //when the user enters the data inside the input collect the value
       var elementValue=event.target.value;
        // get the name that input
       var nameValue=event.target.name;
        //compare with name,bcz names are unique to store inside 
        if(nameValue === 'tTitle'){
            this.title = elementValue;

        }else if(nameValue === 'priority'){
            this.priority = elementValue;
        }
    }
    handleClick(){
        // logic to add the task to the list
        const newTask={
            id:Date.now(),
           title:this.title,
           priority:this.priority
        }
        this.taskList=[...this.taskList,newTask];
    this.title = '';
    this.priority = '';
    }

}