import { LightningElement, api } from 'lwc';
import { notification } from 'c/utility';

export default class NewRecord extends LightningElement {
    @api objectType;
    @api parentId;

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