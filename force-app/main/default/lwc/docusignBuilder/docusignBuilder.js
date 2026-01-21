//============================================
// @description       : DocuSign Rest API/Credential configuration component
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//============================================

import { LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';

// Resource Imports
import DOCUSIGN_STYLES from '@salesforce/resourceUrl/DocusignStyles';

export default class DocusignBuilder extends LightningElement {
    data = [1, 2];
    dragSource = null;

    docusignStyles = DOCUSIGN_STYLES;
    connectedCallback() {
        console.log('Connected Docusign...');
        Promise.all([
            loadStyle(this, `${this.docusignStyles}`)
        ]);

        this.addEventListeners();
    }

    disconnectedCallback() {
        this.removeEventListeners();
    }

    addEventListeners() {
        this.template.addEventListener('dragstart', this.onDragStart.bind(this));
        this.template.addEventListener('dragover', this.onDragOver.bind(this));
        this.template.addEventListener('drop', this.onDrop.bind(this));
    }

    removeEventListeners() {
        this.template.removeEventListener('dragstart', this.onDragStart.bind(this));
        this.template.removeEventListener('dragover', this.onDragOver.bind(this));
        this.template.removeEventListener('drop', this.onDrop.bind(this));
    }

    onDragStart(event) {
        if (event.target.classList.contains('box')) {
            this.dragSource = event.target;
            event.dataTransfer.setData('text/plain', event.target.dataset.id); // Use data to identify the dragged item
        }
    }

    onDragOver(event) {
        event.preventDefault(); // Allow drop
    }

    onDrop(event) {
        event.preventDefault();

        const draggedId = event.dataTransfer.getData('text/plain');
        const draggedBox = this.template.querySelector(`[data-id="${draggedId}"]`);
        const targetBox = event.target.closest('.box');

        if (draggedBox && targetBox && draggedBox !== targetBox) {
            // Move draggedBox to the position before targetBox
            const container = this.template.querySelector('.container');
            container.insertBefore(draggedBox, targetBox);
        }

        this.dragSource = null;
    }
}
