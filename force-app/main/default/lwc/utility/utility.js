/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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