//============================================
// @description       :
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//============================================

import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';

import { generateCalendar, generateYears, DAY_DATA, MONTHS, WEEKDAYS_ABV } from 'c/utility';
import CALENDAR_NAVIGATION_CHANNEL from '@salesforce/messageChannel/CalendarNavigationChannel__c';

export default class CalenderNavigator extends LightningElement {
    months = MONTHS;
    weekdays = WEEKDAYS_ABV;

    currDate = new Date();
    month = this.currDate.getMonth();
    year = this.currDate.getFullYear();

    calendar = [];
    years = [];
    dData = DAY_DATA;

    @wire(MessageContext)
    messageContext;

    post(data) {
        // Pass the configured graph data
        const message = {
            detail: data
        };
        publish(this.messageContext, CALENDAR_NAVIGATION_CHANNEL, message);
    }

    connectedCallback() {
        this.setCalendar();
        this.setYears();
    }

    get day() {
        return this.dData;
    }

    get monthLabel() {
        return this.months[this.month];
    }

    get yearOptions() {
        return this.years;
    }

    updateYears() {
        this.years = this.years.map(year => ({
            ...year,
            selected: year.value === this.year
        }));
    }

    setYears() {
        this.years = [...generateYears(this.year, 25)]; // Replace array to trigger reactivity
    }

    setCalendar() {
        this.calendar = [...generateCalendar(this.year, this.month + 1)]; // Replace array to trigger reactivity
    }

    select(e) {
        this.year = Number(e.target.value);

        this.updateYears();
        this.setCalendar();
    }
    
    navigate(e) {
        let name = e.currentTarget.dataset.name;

        if(name == 'day') {
            let id = e.currentTarget.dataset.id;

            // Flatten the array of weeks into a single array of day objects
            const allDays = this.calendar.flat();

            // Find the day object that matches the given id
            const selectedDay = allDays.find(day => day.id === id);

            this.month = selectedDay.month - 1;
            this.year = selectedDay.year;

            // We want to create a Data Channel to send a message of click event
            this.post(selectedDay);
            this.dData = selectedDay;
        } else if (name === 'nextMonth') {
            if (this.month === 11) {
                this.month = 0;
                this.year += 1;
            } else {
                this.month += 1;
            }
        } else if (name === 'prevMonth') {
            if (this.month === 0) {
                this.month = 11;
                this.year -= 1;
            } else {
                this.month -= 1;
            }
        }

        this.updateYears();
        this.setCalendar();
    }
}
