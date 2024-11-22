import { LightningElement, api } from 'lwc';

const DELAY = 100;
const PAGE_NUMBER = 1;
const PAGE_SIZE_OPTIONS = [5,10,25,50,100];
const SHOW_IT = 'visibility:visible';
const HIDE_IT = 'visibility:hidden'; //visibility keeps the component space, but display:none doesn't

/*
*   TODO:
*   - Add custom events for:
*       - onpagination
*       - onsort
*       - onsearch
*       - onfilter
*/
export default class FilterTable extends LightningElement {
    @api parentId; // Parent Id of the related records
    @api objectType; // Objecvt type of the child records

    @api columns; // Configurable columns for datatable
    @api records; // All records available in the datatable
    @api displayRecords = []; // Records that will display on the page
    @api totalRecords; // Total number of records
    @api isPagination; // Check to see if the pagination is available

    @api delay; // Delay for the search function to refresh
    @api pageNumber; // Current page number
    @api pageSizeOptions; // Available page size Options
    
    sortBy;
    sortDirection;

    title;
    pages; // Total number of pages
    pageSize; // Number of records to by displayed per page
    searchKey; // Primary key for searching {records}
    timeout; // Timeout serves as a var for holding timeout delay

    isPrevious; // Check to see if the previous control for pagination is available
    isNext; // Check to see if the next control for pagination is available
    isNew = false;
    isFilter = false;

    connectedCallback() {
        this.delay = (this.delay != null) ? this.delay : DELAY;
        this.pageNumber = (this.pageNumber != null) ? this.pageNumber : PAGE_NUMBER;
        this.pageSizeOptions = (this.pageSizeOptions != null) ? this.pageSizeOptions : PAGE_SIZE_OPTIONS;
        this.pageSize = this.pageSizeOptions[1];

        this.title = this.objectType +' (' +this.totalRecords+ ')';
        this.setDisplayRecords();
    }

    renderedCallback() {
        if (this.template.querySelector(".slds-select") !== null) {
            this.template.querySelector("option[value='" + this.pageSize + "']").setAttribute("selected", "");
        }
    }

    handlePageSize(e) {
        e.preventDefault();
        this.pageSize = e.target.value;
        this.setDisplayRecords();
    }

    handlePageChange(e) {
        if(e.keyCode === 13) { // Check if enter key was pressed
            this.pageNumber = e.target.value;
            this.setDisplayRecords();
        }
    }

    handleSearch(e) {
        e.preventDefault();

        window.clearTimeout(this.timeout);
        if(e.target.value) {
            this.timeout = setTimeout(() => {
                this.controlPagination = HIDE_IT;
                this.setPaginationControls();
                this.searchKey = e.target.value;
                
                this.displayRecords = this.records;
            }, this.delay);
        } else {
            this.isPagination = true;
            this.setDisplayRecords();
        }
    }

    setDisplayRecords() {
        this.displayRecords = [];
        if(!this.pageSize)
            this.pageSize = this.totalRecords;

        this.pages = Math.ceil(this.totalRecords/this.pageSize);

        this.setPaginationControls();

        for(let i = ((this.pageNumber-1) * this.pageSize); i < (this.pageNumber * this.pageSize); i++) {
            if(i === this.pages) break;
            this.displayRecords.push(this.records[i]);
        }
    }

    setPaginationControls(){
        //Control Pre/Next buttons visibility by Total pages
        if(this.pages === 1) {
            this.isPrevious = false;
            this.isNext = false;
        } else if(this.pages > 1) {
            this.isPrevious = true;
            this.isNext = true;
        }

        //Control Pre/Next buttons visibility by Page number
        if(this.pageNumber <= 1){
            this.pageNumber = 1;
            this.isPrevious = false;
        }else if(this.pageNumber >= this.pages){
            this.pageNumber = this.pages;
            this.isNext = false;
        }

        //Control Pre/Next buttons visibility by Pagination visibility
        if(!this.isPagination) {
            this.isPrevious = false;
            this.isNext = false;
        }
    }

    next(){
        this.pageNumber = this.pageNumber+1;
        this.setDisplayRecords();
    }

    previous(){
        this.pageNumber = this.pageNumber-1;
        this.setDisplayRecords();
    }

    action(e) {
        e.preventDefault();
        const event = new CustomEvent('onrowaction_custom', {
            detail: {
                actionName: e.detail.action.name,
                rowId: e.detail.row.Id,
                row: e.detail.row

            }
        });
        this.dispatchEvent(event);
    }

    save(e) {
        e.preventDefault();
        const event = new CustomEvent('onsave_custom', {
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
        let parseData = JSON.parse(JSON.stringify(this.records));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';  
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.records = parseData;
        this.setDisplayRecords();
    }
}