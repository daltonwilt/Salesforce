/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
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