import LightningDatatable from 'lightning/datatable';
import statusCell from './statusCell.html';
export default class AppointmentStatusDatatable extends LightningDatatable {
//To customize the status with yellow colur along with value we are using
// the custom datatable bcz standard one won't supports 
//here cell will considered as both row + column 
    static customTypes = {

        statusCell: {
            //template is nothing but html file 
            template: statusCell,
            typeAttributes: ['status']
        }

    };

}