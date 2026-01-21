//============================================
// @description       :
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//============================================

import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notification } from 'c/utils';

// Apex Classes
import deepClone from '@salesforce/apex/DeepCloneService.deepClone';

export default class DeepClone extends NavigationMixin(LightningElement) {
    @api recordId;
    cloneMessage;

    constructor() {}

    back(e) {
        e.preventDefault();
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    clickSubmit(e) {
        e.preventDefault();
        this.template.querySelector(`[data-id="submit-button"]`).click();
    }

    submit(e) {
        e.preventDefault();

        let fields = e.detail.fields;
        deepClone({recordId: this.recordId, parentRecord: fields}).then(dCloneId => {

            notification('Sucess', 'Completed deep cloning Order navigating to new Order details.', 'success', 5000);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: dCloneId,
                    objectApiName: 'Order',
                    actionName: 'view'
                }
            });

        }).catch(error => {
            console.error('error', JSON.stringify(error));
            notification('Error', JSON.stringify(error), 'error', 5000);
        });
    }
}
