/**
 * @description       : 
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 * @Todo
 **/
import { LightningElement, wire } from 'lwc';
import { publish, subscribe, unsubscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import { generateWeek, DAY_DATA, MONTHS, WEEKDAYS } from 'c/utility';
import CALENDAR_NAVIGATION_CHANNEL from '@salesforce/messageChannel/CalendarNavigationChannel__c';

// Apex Imports
import getRecordByType from '@salesforce/apex/GenericService.getRecordByType';
import getRecordsByType from '@salesforce/apex/GenericService.getRecordsByType';

export default class CalendarAvailability extends LightningElement {
    weekdays = WEEKDAYS;

    week = [];
    customer;
    dData = DAY_DATA;

    initializing = false;
    message;
    progress;

    subscription = null;
    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        // Subscribe to message channel
        this.subscribeChannel();

        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        const searchId = (urlParams.get('id') != null) ? urlParams.get('id') : null;

        if (searchId != null)
            this.load(searchId);
    }

    disconnectedCallback() {
        // Unsubscribe from message channel during component destruction
        this.unsubscribeChannel();
    }

    subscribeChannel() {
        this.subscription = subscribe(
            this.messageContext,
            CALENDAR_NAVIGATION_CHANNEL,
            (message) => this.handlePost(message.detail),
            {scope: APPLICATION_SCOPE}
        );
    }

    unsubscribeChannel() {
        if (this.subscription) {
            unsubscribe(this.subscription);
            this.subscription = null;
        }
    }

    get day() {
        return this.dData;
    }

    load(id) {
        this.initializing = true;
        this.message = 'Initializing...';
        this.progress = 0/1;

        // Get Customer related to the query id
        getRecordByType({
            objectType: 'dms_Customer__c', 
            configFilter: {Id: id}, 
            orderBy: 'Name DESC',
            rFields: null
        }).then(gCustomerRecord => {
            this.customer = gCustomerRecord;

            this.message = 'Fetched Customer...';
            this.progress = 1/1;
            this.updateWeek();
            this.initializing = false;
        }).catch(error => {
            this.message = 'Error Fetching Customer...';
            this.progress = 1/1;
            setTimeout(() => { this.initializing = false; }, 100);

            console.log('error CalendarAvailability::load.getCustomer');
            console.error(error);
        });
    }

    updateWeek() {
        this.week = generateWeek(this.dData.date);
        this.initializing = true;
        this.message = 'Updating Week...';
        this.progress = 0/1;
        getRecordsByType({
            objectType: 'dms_Service_Appointment__c', 
            configFilter: {'Customer__r.Account__c': this.customer.Account__c}, 
            orderBy: 'Appointment__c DESC',
            rFields: null
        }).then(gServiceAppointments => {
            console.log(gServiceAppointments);

            // Attach appointments to the correlating dates of the week 
            // Loop through gServiceAppointments attach to week related record
            // If Appointment__c matches date add to appointments: [] list for week {}

            for (const sa of gServiceAppointments) {
                console.log('Service Appointment ', new Date(sa.Appointment__c));
                for (const day of this.week) {
                    console.log('Day ', day.date);
                    if (
                        (new Date(sa.Appointment__c)).getDate() == (day.date).getDate() &&
                        (new Date(sa.Appointment__c)).getMonth() == (day.date).getMonth() &&
                        (new Date(sa.Appointment__c)).getFullYear() == (day.date).getFullYear()
                    ) {
                        day.appointments.push(sa);
                    }
                }
            }

            console.log(JSON.stringify(this.week));

            // Create Availability records based off the appointments slots already taken
            // Look through week {} and if there is time that isn't filled create a avaiability record
            // that has start and end time of 1 hour slots
            // For example:
            //      IF Available 9-12 create 3 available records {9-10} {10-11} {11-12
            
            this.message = 'Fetched Service Appointemnts...';
            this.progress = 1/1;
            setTimeout(() => { this.initializing = false; }, 100);
        }).catch(error => {
            this.message = 'Error Fetching Service Appointments...';
            this.progress = 1/1;
            setTimeout(() => { this.initializing = false; }, 100);

            console.log('error CalendarAvailability::load.getServiceAppointments');
            console.error(error);
        });
    }

    handlePost(e) {
        this.dData = e;
        this.updateWeek();
    }
}
