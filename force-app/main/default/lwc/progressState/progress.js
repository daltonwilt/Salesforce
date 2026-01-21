//============================================
// @description       : Simple progression UI display when rerending pages or get/set data.
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//============================================

import { LightningElement, api } from 'lwc';

export default class Progress extends LightningElement {
    @api message;
    @api progress;
    @api modal;

    renderedCallback() {
        this.progress = this.progress * 100;
        
        let progressBar = this.template.querySelector('.progress-bar__value');
        progressBar.style.width = `${this.progress}%`;
    }
}
