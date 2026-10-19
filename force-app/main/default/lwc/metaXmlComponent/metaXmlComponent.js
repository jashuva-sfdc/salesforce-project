import { LightningElement,api} from 'lwc';

export default class MetaXmlComponent extends LightningElement {
    @api objectApiName;
    @api fieldApiName;
    @api noOfRecords;
    @api recordId;
}