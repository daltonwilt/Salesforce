/**
 * Utility JS for reausable methods.
 * 
 * @author            : dalton@bluecitystudios.com
 * @last modified on  : 9/15/2025
 * @last modified by  : dalton@bluecitystudios.com
 * @todo
 */
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//==============================================================================
// Generic utility functions
//==============================================================================

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

export function cEvent(evt_Name, evt_Detail) {
    const evt = new CustomEvent(evt_Name, {
        detail: evt_Detail,
        bubbles: true,
        composed: true
    });
    dispatchEvent(evt);
}

export function formatDate(sDate) {
    // Convert the date string to a Date object
    const date = new Date(sDate);

    // Format the date as "Thursday, September 5"
    const options = { weekday: 'short', month: 'short', day: 'numeric' };
    return new Intl.DateTimeFormat('en-US', options).format(date);
}

export function formatTime(milliseconds) {        
    // Convert milliseconds to total seconds
    const totalSeconds = Math.floor(milliseconds / 1000);
    
    // Calculate hours, minutes, and seconds
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    
    // Determine AM/PM
    const ampm = hours >= 12 ? 'PM' : 'AM';
    
    // Convert to 12-hour format
    const hour12 = hours % 12 || 12; // Converts '0' to '12'
    
    // Format minutes and seconds to always be two digits
    const formattedMinutes = minutes.toString().padStart(2, '0');
    
    // Return formatted time (excluding seconds for simplicity)
    return `${hour12}:${formattedMinutes} ${ampm}`;
}

//==============================================================================
// Utility functions for initializing records specific to {Client}
//==============================================================================
