/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
*  @todo:
*   - Add custom events for:
*       - onpagination
*       - onsort
*       - onsearch
*       - onfilter
*/
import { LightningElement, api } from 'lwc';

const DELAY = 100;
const PAGE_NUMBER = 1;
const PAGE_SIZE_OPTIONS = [5,10,25,50,100];

export default class DwFilterTable extends LightningElement {
    @api recordId; // Parent Id of the related records
    @api objectType; // Object type of the child records

    @api columns; // Configurable columns for datatable
    @api records; // All records available in the datatable
    displayRecords = []; // Records that will display on the page

    @api delay; // Delay for the search function to refresh
    @api pageSize; // Number of records to by displayed per page
    @api pageNumber; // Current page number
    @api pageSizeOptions; // Available page size Options

    sortBy;
    sortDirection;

    @api title;

    isNew = false;
    isFilter = false;

    connectedCallback() {
        this.delay = this.delay ?? DELAY;
        this.pageSize = this.pageSize ?? PAGE_SIZE_OPTIONS[0];        
        this.pageNumber = this.pageNumber ?? PAGE_NUMBER;
        this.pageSizeOptions = this.pageSizeOptions ?? PAGE_SIZE_OPTIONS;
        this.title = `${this.title} (${this.records.length})`;
    }

    get recordsToDisplay() {
        return this.displayRecords;
    }

    paginatorChange(e) {
        e.preventDefault();
        this.displayRecords = e.detail;
    }

    action(e) {
        e.preventDefault();
        const event = new CustomEvent('actioncustom', {
            detail: {
                name: e.detail.action.name,
                rowId: e.detail.row.Id,
                row: e.detail.row

            }
        });
        this.dispatchEvent(event);
    }

    save(e) {
        e.preventDefault();
        const event = new CustomEvent('savecustom', {
            detail: {
                draftValues: e.detail.draftValues,
            }
        });
        this.dispatchEvent(event);
    }

    create(e) {
        e.preventDefault();
        this.isNew = !this.isNew;
    }

    filter(e) {
        e.preventDefault();
        this.isFilter = !this.isFilter;
    }

    sorting(e) {
        e.preventDefault();
        this.sortBy = e.detail.fieldName;
        this.sortDirection = e.detail.sortDirection;
        this.sort(this.sortBy, this.sortDirection);
    }

    sort(fieldname, direction) {
        const parseData = [...this.recordsToDisplay]; // Clone recordsToDisplay to avoid mutation
        const keyValue = (a) => a[fieldname] ?? ''; // Handle undefined or null values
    
        const isReverse = direction === 'asc' ? 1 : -1;
    
        parseData.sort((x, y) => {
            const xVal = keyValue(x).toString().toLowerCase();
            const yVal = keyValue(y).toString().toLowerCase();
            return isReverse * ((xVal > yVal) - (yVal > xVal));
        });
    
        this.displayRecords = parseData;
    }
}