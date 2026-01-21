/**
 * @description       :
 * @author            : dalton@outlook.com
 * @last modified on  : 4/30/2025
 * @last modified by  : dalton@outlook.com
 * @Todo
 **/
import { LightningElement, api } from 'lwc';

export default class LwcFilterSetting extends LightningElement {
    @api objectType;
    @api recordId;

    reload = false;

    cancel(e) {
        e.preventDefault();
        const event = new CustomEvent('back');
        this.dispatchEvent(event);
    }

    save(e) {
        e.preventDefault();
    }
}
