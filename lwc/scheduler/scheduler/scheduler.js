import { LightningElement, api } from 'lwc';
import { notification } from 'c/utility';

// Apex Imports
import getCustomers from '@salesforce/apex/GenericService.getRecordsByType';

export default class Dms_scheduler extends LightningElement {
    customer;
    customers;

    constructor() {
        super();
    }

    connectedCallback() {
        getCustomers({objectType: 'dms_Customer__c', filter: null, orderBy: null}).then(gCustomers => {
            this.customers = gCustomers;
            console.log('Dms_customerSearch::getCustomers ', JSON.stringify(customers));

        }).catch(error => {
            console.error('Dms_customerSearch::getCustomers ', JSON.stringify(error));
        })
    }
}
