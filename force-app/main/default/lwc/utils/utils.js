/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 5/21/2025
 * @last modified by  : dalton@bluecitystudios.com
 **/
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
// Utility functions for initializing records specific to Tropic
//==============================================================================

export function initRecord(record, data, type) {
    if(type == 'Order')
        record = order(record, data);

    if(type == 'Quote')
        record = quote(record, data);

    if(type == 'Request')
        record = request(record, data);

    return record;
}

function order(record, data) {
    record.AccountId = data.AccountId;

    record = base(record, data);
    return record;
}

function quote(record, data) {
    record.Name = data.Name;
    record.BillingName = (data.Account.Name != null) ? data.Account.Name : '';
    record.ShippingName = (data.Name != null) ? data.Name : '';

    record = base(record, data);
    return record;
}

function request(record, data) {
    record.Opportunity__c = data.Id;
    record.AddressStreet = (data.Shipping_Street__c != null) ? data.Shipping_Street__c : '';
    record.AddressCity = (data.Shipping_City__c != null) ? data.Shipping_City__c : '';
    record.AddressState = (data.Shipping_State__c != null) ? data.Shipping_State__c : '';
    record.AddressPostalCode = (data.Shipping_Postal_Code__c != null) ? data.Shipping_Postal_Code__c : '';

    record.Contract_Length__c = 12;
    record.Needs_Delivery__c = 'Yes';
    record.Delivery_Fee__c = 0;
    record.Installation_Fee__c = 0;
    record.Monitoring_Fee__c = 0;
    record.Pickup_Fee__c = 0;
    record.Rental_Fee__c = 0;
    return record;
}

function base(record, data) {
    record.Status = 'Draft';
    record.Pricebook2Id = '01s36000004dyqyAAA';
    record.OpportunityId = data.Id;
    
    record.BillToContactId = (data.Billing_Contact__c != null) ? data.Billing_Contact__c : '';
    record.BillingStreet = (data.Billing_Street__c != null) ? data.Billing_Street__c : '';
    record.BillingCity = (data.Billing_City__c != null) ? data.Billing_City__c : '';
    record.BillingState = (data.Billing_State__c != null) ? data.Billing_State__c : '';
    record.BillingPostalCode = (data.Billing_Postal_Code__c != null) ? data.Billing_Postal_Code__c : '';

    record.ShipToContactId = (data.Shipping_Contact__c != null) ? data.Shipping_Contact__c : '';
    record.ShippingStreet = (data.Shipping_Street__c != null) ? data.Shipping_Street__c : '';
    record.ShippingCity = (data.Shipping_City__c != null) ? data.Shipping_City__c : '';
    record.ShippingState = (data.Shipping_State__c != null) ? data.Shipping_State__c : '';
    record.ShippingPostalCode = (data.Shipping_Postal_Code__c != null) ? data.Shipping_Postal_Code__c : '';
    return record;
}