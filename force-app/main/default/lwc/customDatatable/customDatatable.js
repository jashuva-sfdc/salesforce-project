import LightningDatatable from 'lightning/datatable';

import picklistTemplate from './picklistTemplate.html'
export default class CustomDatatable extends LightningDatatable {
    
    //we have to create a custom data type as picklist / register the data type
    //bcz lightning datatable will supports only few data types those are .. phone,url,text,email
    //...etc but it won't supports picklist 
    static customTypes={
        picklist:{
            template:picklistTemplate,
         // These are the attributes that we want to pass from the parent datatable to the custom picklist component.
            typeAttributes:[
                'options',
                 'value',
                 'context'
            ]
        }
    }

}