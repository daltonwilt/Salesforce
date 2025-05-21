/**
 * @description       : 
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 4/30/2025
 * @last modified by  : dalton@bluecitystudios.com
 * @Todo
 **/
import { LightningElement, api } from 'lwc';

const DELAY = 100;
const PAGE_NUMBER = 1;
const PAGE_SIZE_OPTIONS = [5,10,25,50,100];

export default class LwcPaginator extends LightningElement {
    @api records; // All records available in the datatable
    displayRecords = []; // Records that will display on the page

    @api delay; // Delay for the search function to refresh
    @api pageSize; // Number of records to by displayed per page
    @api pageNumber; // Current page number
    @api pageSizeOptions; // Available page size Options
    pages; // Total number of pages

    searchKey; // Primary key for searching {records}
    timeout; // Timeout serves as a var for holding timeout delay

    isPrevious; // Check to see if the previous control for pagination is available
    isNext; // Check to see if the next control for pagination is available

    connectedCallback() {
        this.delay = this.delay ?? DELAY;
        this.pageSize = this.pageSize ?? PAGE_SIZE_OPTIONS[0];        
        this.pageNumber = this.pageNumber ?? PAGE_NUMBER;
        this.pageSizeOptions = this.pageSizeOptions ?? PAGE_SIZE_OPTIONS;
        this.setDisplayRecords();
    }

    renderedCallback() {
        if (this.template.querySelector(".slds-select") !== null)
            this.template.querySelector("option[value='" + this.pageSize + "']").setAttribute("selected", "");
    }

    changePageSize(e) {
        e.preventDefault();
        this.pageSize = e.target.value;
        this.setDisplayRecords();
    }

    changePage(e) {
        if(e.keyCode === 13) { // Check if enter key was pressed
            this.pageNumber = e.target.value;
            this.setDisplayRecords();
        }
    }

    search(e) {
        e.preventDefault();
        window.clearTimeout(this.timeout);

        this.searchKey = e.target.value.toLowerCase();
        this.timeout = setTimeout(() => {
            if (this.searchKey) {
                this.displayRecords = this.records.filter(record => 
                    Object.values(record).some(value =>
                        value.toString().toLowerCase().includes(this.searchKey)
                    )
                );
                this.dispatchEvent(new CustomEvent('paginatorchange', {detail: this.displayRecords}));
            } else {
                this.setDisplayRecords(); // Reset to full list when search is cleared
            }
        }, this.delay);
    }

    next() {
        this.pageNumber = this.pageNumber+1;
        this.setDisplayRecords();
    }

    previous() {
        this.pageNumber = this.pageNumber-1;
        this.setDisplayRecords();
    }

    setDisplayRecords() {
        if (!this.pageSize) this.pageSize = this.records.length;
        this.pages = Math.ceil(this.records.length / this.pageSize);
        this.setPaginationControls();

        const startIdx = (this.pageNumber - 1) * this.pageSize;
        const endIdx = Math.min(this.pageNumber * this.pageSize, this.records.length);
        this.displayRecords = this.records.slice(startIdx, endIdx); // Slice the records array
        this.dispatchEvent(new CustomEvent('paginatorchange', {detail: this.displayRecords})); //Send records to display on table to the parent component
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
    }
}