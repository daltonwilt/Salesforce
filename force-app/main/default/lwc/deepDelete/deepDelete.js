/**
 * @description       : Override deletion component in order to bypass standard 
*                       Salesforce Validations as well as choosing which branches to delete
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

// Apex Classes
import getRelatedRecords from '@salesforce/apex/Service.getRelatedAllRecords';
// import deleteRecords from '@salesforce/apex/Service.deleteRecords';

// Resource Imports
import TROPIC_STYLES from '@salesforce/resourceUrl/Tropic_Styles';

export default class DeepDelete extends NavigationMixin(LightningElement) {
    @api recordId;

    isModal = false;
    relatedRecords;

    tropicStyle = TROPIC_STYLES;
    constructor() {
        super();
        Promise.all([
            loadStyle(this, `${this.tropicStyle}`)
        ]);
    }

    connectedCallback() {
        getRelatedRecords({ id: this.recordId }).then(result => {
            this.relatedRecords = result;
            console.log('Related Records:', JSON.stringify(this.relatedRecords));
        }).catch(error => {
            console.error('Error:', error);
        });
    }

    cancel(e) {
        e.preventDefault();
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    deleteRecords() {
        // deleteRecords({ records: this.relatedRecords }).then(result => {
        //     this.dispatchEvent(new CloseActionScreenEvent());
        //     notification('Success', 'You have successfully deleted all records.', 'success', 5000);
        // }).catch(error => {
        //     console.error('Error:', error);
        //     notification('Error', JSON.stringify(error), 'error', 5000);
        // });
    }
}