import { LightningElement } from 'lwc';

export default class TomAndJerryComponent extends LightningElement {
    showTom=false;

    users=[
        {firstName:'Tom', lastName:'Raja'},
        {firstName:'Cat', lastName:'Janny'},
        {firstName:'Abhi',lastName:'Mohith'}
    ]
}