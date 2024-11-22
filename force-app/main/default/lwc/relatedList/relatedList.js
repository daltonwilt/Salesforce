/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
import { LightningElement, api } from 'lwc';
import { notification } from 'c/utility';

// Apex Imports
import getRecords from '@salesforce/apex/GenericService.getRecords';

// For example
const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type : 'text', hideDefaultActions: true, sortable: "true"},
    { label: 'Shipping Street', fieldName: 'ShippingStreet', type : 'text', hideDefaultActions: true, sortable: "true"},
    { label: 'Close Date', fieldName: 'CloseDate', type : 'date', hideDefaultActions: true, sortable: "true"},
    { label: 'Status', fieldName: 'StageName', type : 'text', hideDefaultActions: true, sortable: "true"},
    // { type: 'action', typeAttributes: {
    //     rowActions: [
    //         { label: 'Edit', name: 'edit_opportunity'},
    //         { label: 'Delete', name: 'delete'},
    //     ],
    //     menuAlignment: 'auto'
    // }},
];

export default class RelatedList extends LightningElement {
    @api recordId;
    @api isPagination;

    columns = COLUMNS;
    records;
    totalRecords;
    delay = 100;
    pageNumber = 1;
    pageSizeOptions = [5,10,15,20,25];

    connectedCallback() {
        this.isPagination = true;

        getRecords({id: this.recordId}).then(gRecords => {
            this.records = gRecords;
            this.totalRecords = this.records.length;

            console.log('columns ', JSON.stringify(this.columns));
            console.log('records ', JSON.stringify(this.records));
            console.log('totalRecords ', JSON.stringify(this.totalRecords));
            console.log('isPagination ', JSON.stringify(this.isPagination));
            console.log('delay ', JSON.stringify(this.delay));
            console.log('pageNumber ', JSON.stringify(this.pageNumber));
            console.log('pageSizeOptions ', JSON.stringify(this.pageSizeOptions));
        }).catch(error => {
            console.error('RelatedList::getRecords ', JSON.stringify(error));
        })
    }
}
