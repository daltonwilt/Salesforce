/**
 * @description       : Serves as an override to standard lightning-datatable since it just sucks
 *                      and we need it to do more than it offers
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 4/30/2025
 * @last modified by  : dalton@bluecitystudios.com
 * @Todo
 **/
import LightningDatatable from 'lightning/datatable';

import cNonEditTemplate from './cNonEditTemplate.html';
import cAddress from './cAddress.html';
import cFileUpload from './cFileUpload.html';
import cImageTemplate from './cImage.html';
import cLookup from './cLookup.html';
import cPicklistTemplate from './cPicklist.html';

export default class LwcDataTable extends LightningDatatable {
    static customTypes = {
        cAddress: {
            template: cNonEditTemplate,
            template: cAddress,
            standardCellLayout: true,
            typeAttributes: ['googleURL', 'street', 'city', 'country', 'province', 'postalCode'],
        },
        cFileUpload: {
            template: cNonEditTemplate,
            template: cFileUpload,
            standardCellLayout: true,
            typeAttributes: ['acceptedFormats','doUpload']
        },
        cImage: {
            template: cNonEditTemplate,
            template: cImageTemplate,
            standardCellLayout: true,
            typeAttributes: ['alttxt','width','height'],
        },
        cLookup : {
            template: cLookup,
            edittemplate: cLookup,
            standardCellLayout: true,
            typeAttributes: ['name', 'label', 'icon', 'variant', 'placeholder', 'object', 'fields', 'displayFields', 'valueId', 'valueName', 'currentRecordId'],
        },
        cPicklist: {
            template: cNonEditTemplate,
            editTemplate: cPicklistTemplate,
            standardCellLayout: true,
            typeAttributes : ['label', 'placeholder', 'options', 'value', 'context', 'variant','name']
        }
    }
}