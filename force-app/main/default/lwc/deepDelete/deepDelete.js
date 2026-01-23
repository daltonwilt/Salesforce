//============================================
// @description       : Override delete component in order to bypass standard Salesforce validations as well as choosing which branches to delete.
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//============================================

import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

// Apex Classes
import getRelatedRecords from '@salesforce/apex/Service.getRelatedAllRecords';
import deepDelete from '@salesforce/apex/Service.deepDelete';

export default class DeepDelete extends NavigationMixin(LightningElement) {
    @api recordId;

    isModal = false;
    records;

    constructor() {}

    connectedCallback() {
        getRelatedRecords({ id: this.recordId }).then(result => {
            this.records = result;
            console.log('Related Records:', JSON.stringify(this.records));
        }).catch(error => {
            console.error('Error:', error);
        });
    }

    cancel(e) {
        e.preventDefault();
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    delete() {
        deepDelete({ records: this.records }).then(result => {
            this.dispatchEvent(new CloseActionScreenEvent());
            notification('Success', 'You have successfully deleted all records.', 'success', 5000);
        }).catch(error => {
            console.error('Error:', error);
            notification('Error', JSON.stringify(error), 'error', 5000);
        });
    }
}
