/**
 * @description       : Allow for full cloning of related tree records instead of just the parent
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notification } from 'c/utils';

// Apex Classes
import deepClone from '@salesforce/apex/DeepCloneService.deepClone';

// Resource Imports
import tropicStyle from '@salesforce/resourceUrl/Tropic_Styles';

export default class DeepClone extends NavigationMixin(LightningElement) {
    @api recordId;
    cloneMessage;

    tropicStyle = tropicStyle;
    constructor() {
        super();
        Promise.all([
            loadStyle(this, `${this.tropicStyle}`)
        ]);
    }

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