/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
import { LightningElement, api } from 'lwc';
import { notification } from 'c/utility';

export default class CNewRecord extends LightningElement {
    @api objectType;
    @api recordId;
    @api recordAPI;

    reload = false;

    cancel(e) {
        e.preventDefault();
        const event = new CustomEvent('back');
        this.dispatchEvent(event);
    }

    clickSubmit(e) {
        e.preventDefault();
        this.template.querySelector(`[data-id="submit-button"]`).click();
    }

    error(e) {
        e.preventDefault();
        notification('Error', 'Error attemping to create the record. ' + e.body.message, 'error', 5000);
    }

    success(e) {
        e.preventDefault();
        notification('Success', 'Succesfully created the record.', 'success', 5000);
        const event = new CustomEvent('back');
        this.dispatchEvent(event);
    }
}