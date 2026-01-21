/**
 * @description       : Serves as an override to standard lightning-datatable since it just sucks
 *                      and we need it to do more than it offers
 * @author            : dalton@outlook.com
 * @group             :
 * @last modified on  : 4/30/2025
 * @last modified by  : dalton@outlook.com
 * @Todo
 **/
import { LightningElement, api } from 'lwc';
import { notification } from 'c/utils';

export default class LwcNewRecord extends LightningElement {
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
