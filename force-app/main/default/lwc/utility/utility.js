/**
 * @description       : 
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 * @Todo
 **/
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
export const WEEKDAYS_ABV = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
export const WEEKDAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

export const DAY_DATA = {
    id: `${new Date().getFullYear()}-${new Date().getMonth() + 1}-${new Date().getDate()}`,
    date: new Date(),
    year: new Date().getFullYear(),
    month: new Date().getMonth() + 1,
    monthName: MONTHS[new Date().getMonth()],
    day: new Date().getDate(),
    dayName: WEEKDAYS[new Date().getDay()],
    isToday: true,
    isCurrentMonth: true,
};

// Method for display notification alert banners
export function notification(ntf_Title, ntf_Message, ntf_Variant, ntf_Duration) {
    const evt = new ShowToastEvent({
        title: ntf_Title,
        message: ntf_Message,
        variant: ntf_Variant,
        duration: ntf_Duration,
        mode: 'dismissable'
    });
    dispatchEvent(evt);
}

export function cEvent(evt_Name, evt_Bubbles, evt_Composed, evt_Cancelable, evt_Detail) {
    const event = new CustomEvent(evt_Name, {
        bubbles: evt_Bubbles,
        composed: evt_Composed,
        cancelable: evt_Cancelable,
        detail: evt_Detail
    });
    this.dispatchEvent(event);
}

export function generateYears(currentYear, range) {
    const years = [];
    for (let year = currentYear - range; year <= currentYear + range; year++) {
        years.push({
            label: year,
            value: year,
            selected: year === currentYear,
        });
    }
    return years;
}

export function generateCalendar(year, month) {
    const weeks = [];
    const firstDayOfMonth = new Date(year, month - 1, 1);
    const startDate = getStartDate(firstDayOfMonth);
    const endDate = getEndDate(startDate, 42);
    
    const days = getDaysInRange(startDate, endDate, month);

    // Group days into weeks (7 days per week)
    while (days.length) weeks.push(days.splice(0, 7));

    return weeks;
}

export function generateWeek(date) {
        const iDate = new Date(date);

        // Get the day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
        const day = iDate.getDay();

        // Calculate the start (Sunday) of the week
        const sunday = new Date(iDate);
        sunday.setDate(iDate.getDate() - day);
        const endDate = getEndDate(sunday, 7);
    
        return getDaysInRange(sunday, endDate, iDate.getMonth());;
}

function getStartDate(pDate) {
    const startDate = new Date(pDate);
    startDate.setDate(startDate.getDate() - startDate.getDay()); // Go back to previous Sunday
    return startDate;
}

function getEndDate(pDate, days) {
    const endDate = new Date(pDate);
    endDate.setDate(pDate.getDate() + (days) - 1); // Ensure 6 weeks (42 days)
    return endDate;
}

function getDaysInRange(startDate, endDate, month) {
    const days = [];
    let today = new Date();
    let currentDate = new Date(startDate);

    while (currentDate <= endDate) {
        days.push({
            id: `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${currentDate.getDate()}`,
            date: new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate()),
            year: currentDate.getFullYear(),
            month: currentDate.getMonth() + 1,
            monthName: MONTHS[currentDate.getMonth()],
            day: currentDate.getDate(),
            dayName: WEEKDAYS[currentDate.getDay()],
            isToday: currentDate === today,
            isCurrentMonth: currentDate.getMonth() === month - 1,
        });
        currentDate.setDate(currentDate.getDate() + 1);
    }

    return days;
}
