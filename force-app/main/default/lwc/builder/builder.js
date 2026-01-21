//============================================
// @description       :
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//============================================

import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';

// Apex Imports
import getBuilder from '@salesforce/apex/BuilderService.getBuilder';
import getBuilderComponents from '@salesforce/apex/BuilderService.getBuilderComponents';

// Resource Imports
import BUILDER_STYLES from '@salesforce/resourceUrl/Builder';

export default class Builder extends LightningElement {
    @api recordId;

    // State to track panel visibility
    isStylePanelVisible = true;
    isComponentPanelVisible = true;

    // State to track resizing directions
    isResizing = false;
    isResizingX = false;
    isResizingY = false;

    // Track the starting point when moving components
    startX = 0;
    startY = 0;
    startWidth = 0;
    startHeight = 0;

    divId = '';
    dragSource = null;
    droppedItems = [];

    pageNumber;
    page;

    builder;
    builderComponents;

    components = [];
    componentsToImport = [];

    componentConstructor;
    builderStyles = BUILDER_STYLES;

    async connectedCallback() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.pageNumber = urlParams.get('page');

        /* Get Builder configuration */
        getBuilder().then(gBuilder => {
            this.builder = gBuilder;
            this.page = this.builder.Builder_Pages__r[0]; // Default page to first
    
            for(const p of this.builder.Builder_Pages__r) {
                if(p.Order__c == this.pageNumber)
                    this.page = p;

                for(const r of p.Builder_Rows__r) {
                    for(const cl of r.Builder_Columns__r) {
                        for(const ct of cl.Builder_Contents__r) {
                            if(!this.componentsToImport.includes(ct.Builder_Component__r.Component__c) && ct.Builder_Component__r != null) {
                                this.componentsToImport.push(ct.Builder_Component__r.Component__c);
                            }
                        }
                    }
                }
            }

            for(const c in this.componentsToImport) {
                console.log('c ::', JSON.stringify(this.componentsToImport[c]));
            }
    
    
            console.log('Components :: ', JSON.stringify(this.componentsToImport));
    
            this.addEventListeners();
            // this.load();
        }).catch(error => {
            console.log('Builder:::getBuilder ', (JSON.stringify(error)));
        })

        getBuilderComponents().then(gBuilderComponents => {
            this.builderComponents = gBuilderComponents;
        }).catch(error => {
            console.log('Builder:::getBuilderComponents ', (JSON.stringify(error)));
        })

        // Put this into the getBuilder() method and log the componentConstructor to Builder Component
        const { default: ctor } = await import("c/docusignBuilder");
        this.componentConstructor = ctor;
        console.log('ctor ', JSON.stringify(this.componentConstructor));

        /* Load Styles */
        Promise.all([
            loadStyle(this, `${this.builderStyles}`)
        ]);
    }

    disconnectedCallback() {
        this.removeEventListeners();
    }

    /*
    // Query template based on target config pass
    load() {
        // QUERY: Template for presentation
        template(id: this.templateId).then(template => {
            let stylePaths = [];
            // Loop through template getting all style paths
            // Load ONLY styles related to the page we are on
            for(const path in stylePaths) {
                Promise.all([
                    loadStyle(this, `${path}`)
                ]);
            }
        }).catch(errory => {

        });
    }
    */

    // Add listeners for mouse and drag movement
    addEventListeners() {
        this.template.addEventListener('mousedown', this.onMouseDown.bind(this));
        this.template.addEventListener('mousemove', this.onMouseMove.bind(this));
        window.addEventListener('mouseup', this.onMouseUp.bind(this));

        this.template.addEventListener('dragstart', this.onDragStart.bind(this));
        this.template.addEventListener('dragover', this.onDragOver.bind(this));
        this.template.addEventListener('drop', this.onDrop.bind(this));
    }

    // Remove listeners for mouse and drag movement
    removeEventListeners() {
        this.template.removeEventListener('mousedown', this.onMouseDown.bind(this));
        this.template.removeEventListener('mousemove', this.onMouseMove.bind(this));
        window.removeEventListener('mouseup', this.onMouseUp.bind(this));

        this.template.removeEventListener('dragstart', this.onDragStart.bind(this));
        this.template.removeEventListener('dragover', this.onDragOver.bind(this));
        this.template.removeEventListener('drop', this.onDrop.bind(this));
    }

    // Event handlers for listeners
    onMouseDown(event) {
        if (event.target.classList.contains('resizer')) {
            event.preventDefault(); // Prevent text selection during drag

            this.isResizing = true;
            this.startX = event.clientX;
            this.startY = event.clientY;
            this.divId = event.target.dataset.id;
            
            const content = this.template.querySelector(`[data-id="${this.divId}"]`);
            this.startWidth = content.offsetWidth;
            this.startHeight = content.offsetHeight;
    
            // Determine which resizer was clicked
            this.isResizingX = event.target.classList.contains('resizer-horizontal') || event.target.classList.contains('resizer-corner');
            this.isResizingY = event.target.classList.contains('resizer-vertical') || event.target.classList.contains('resizer-corner');
        }
    }

    onMouseMove(event) {
        if (this.isResizing) {
            const content = this.template.querySelector(`[data-id="${this.divId}"]`);
    
            const dx = event.clientX - this.startX;
            const dy = event.clientY - this.startY;

            const newWidth = this.startWidth + dx;  // Direct pixel calculation
            const newHeight = this.startHeight + dy;  // Direct pixel calculation
    
            if (this.isResizingX && newWidth > 5) {  // Allow expansion beyond 100%
                content.style.width = `${newWidth}px`;
            }

            if (this.isResizingY && newHeight > 5) {  // Allow expansion beyond 100%
                content.style.height = `${newHeight}px`;
            }
        }
    }

    onMouseUp(event) {
        this.isResizing = false;
        this.isResizingX = false;
        this.isResizingY = false;

        // Store new sizes on the corresponding configurations
    }

    onDragStart(event) {
        this.dragSource = event.target;
        event.dataTransfer.setData('text/plain', event.target.dataset.id); // Use data to identify the dragged item
        event.dataTransfer.effectAllowed = 'move';
    }

    onDragOver(event) {
        event.preventDefault(); // Allow drop
        event.dataTransfer.dropEffect = 'move'; // Visual feedback for allowed drop
    }

    onDrop(event) {
        event.preventDefault(); // Prevent default behavior

        const draggedId = event.dataTransfer.getData('text/plain');
        const draggedComponent = this.builderComponents.find((component) => component.Id === draggedId);

        // Prevent adding the same item multiple times
        if (!this.droppedComponents.some((i) => i.id === draggedComponent.Id)) {
            this.droppedComponents = [...this.droppedComponents, draggedComponent];
        }
    }

    // Toggle visibility for Style Panel
    toggleStylePanel(event) {
        this.isStylePanelVisible = !this.isStylePanelVisible;
    }

    next(event) {}

    back(event) {}

    // Sort functionality for array order
    sort(data) {
        data.sort((a, b) => a.Order__c - b.Order__c);
    }
}
