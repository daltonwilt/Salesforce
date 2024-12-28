import { LightningElement, api } from 'lwc';

export default class ProgressState extends LightningElement {
    @api message;
    @api progress;
    @api modal;

    renderedCallback() {
        this.progress = this.progress * 100;
        
        let progressBar = this.template.querySelector('.progress-bar__value');
        progressBar.style.width = `${this.progress}%`;
    }
}