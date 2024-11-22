/**
 * @description       : Custom Lightning datatable to add other field type features that standard
 *                      lightning-datatable doesn't have
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
import LightningDatatable from 'lightning/datatable';

import cNonEditTemplate from './nonEditTemplate.html';
import cFileUpload from './fileUpload.html';
import cImageTemplate from './image.html';
import cLookup from './lookup.html';
import cPicklistTemplate from './picklist.html';

export default class LwcDataTable extends LightningDatatable {
    static customTypes = {
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
            template: cNonEditTemplate,
            template: cLookup,
            standardCellLayout: true,
            typeAttributes: ['object', 'icon', 'label', 'placeholder', 'fields', 'displayFields', 'valueId', 'valueName','currentRecordId'],
        },
        cPicklist: {
            template: cNonEditTemplate,
            editTemplate: cPicklistTemplate,
            standardCellLayout: true,
            typeAttributes : ['label', 'placeholder', 'options', 'value', 'context', 'variant','name']
        }
    }
}