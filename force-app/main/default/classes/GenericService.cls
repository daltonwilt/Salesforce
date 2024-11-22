/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
public without sharing class GenericService {
    public GenericService() {}

    /**
     * Retrieves all the records pertaining to search criteria
     * 
     * @param objectType
     * @param fields
     * @param term
     * @return A list of records pertaining to search criteria
     */
    @AuraEnabled
    public static List<SObject> search(String objectType, List<String> fields, String term){
        // try {
            String keyword = term + '*';
            String query = 'FIND :keyword IN ALL FIELDS RETURNING ' +objectType+ '(Id,' +String.join(fields,',')+ ')' + ' LIMIT 20';

            List<List<sObject>> records = new List<List<sObject>>();
            List<SObject> sobjList = new List<SObject>();
            if(String.isBlank(term)){
                String soqlQuery = 'SELECT Id, Name, Type, LastViewedDate FROM RecentlyViewed WHERE Type =\''+objectType+'\' ORDER BY LastViewedDate DESC LIMIT 5';
                sobjList = Database.query( soqlQuery );
                records.add(sobjList);
            } else {
                records = Search.Query(Query);
            }

            return records.get(0);
        // } catch(Exception e) {
        //     throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        // }
    }

    /**
     * Retrieves all the records pertaining to search criteria
     * 
     * @param recordId
     * @param fields
     * @param objectType
     * @return A list of records pertaining to search criteria
     */
    @AuraEnabled
    public static sObject getRecentlyCreatedRecord(String recordId, List<String> fields, String objectType){
        sObject record;
        // try {
            String query = 'SELECT Id,' +String.join(fields,',')+ ' FROM ' +objectType+ ' WHERE Id = \'' +recordId+ '\'';
            List<SObject> records = Database.query( query );
            record = records.get(0);
        // } catch (Exception e) {
        //     throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        // }
        
        return record;
    }

        /**
     * Retrieves all the records and their fields based on the Id param
     * 
     * @param id The Id of the object whose fields are to be retrieved
     * @return A record pertaining to the Id
     */
    @AuraEnabled
    public static SObject getRecordById(Id id, String filter, String orderBy){
        try {
            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getDirectFieldsById(id) +' FROM '+ id.getSObjectType().getDescribe().getName();
            if(filter != null) query = query +' WHERE '+ filter;
            if(orderBy != null) query = query +' ORDER BY '+ orderBy;
            query = query + ' LIMIT 1';
            
            // Execute the query and retrieve the record
            SObject result = Database.query(query);
        
            return result;
        } catch(Exception e) {
            throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        }
    }

    /**
     * Retrieves all the records and their fields based on the Id param
     * 
     * @param id The Id of the object whose fields are to be retrieved
     * @return A list of records pertaining to the Id
     */
    @AuraEnabled
    public static List<SObject> getRecordsById(Id id, String filter, String orderBy){
        // try {
            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getDirectFieldsById(id) +' FROM '+ id.getSObjectType().getDescribe().getName();
            if(filter != null) query = query +' WHERE '+ filter;
            if(orderBy != null) query = query +' ORDER BY '+ orderBy;
            
            // Execute the query and retrieve the record
            List<SObject> result = Database.query(query);
        
            return result;
        // } catch(Exception e) {
        //     throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        // }
    }

        /**
     * Retrieves all the records and their fields based on the Id param
     * 
     * @param id The Id of the object whose fields are to be retrieved
     * @return A list of records pertaining to the Id
     */
    @AuraEnabled
    public static List<SObject> getRecordsByType(String objectType, String filter, String orderBy){
        // try {
            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getDirectFieldsByType(objectType) +' FROM '+ objectType;
            if(filter != null) query = query +' WHERE '+ filter;
            if(orderBy != null) query = query +' ORDER BY '+ orderBy;
            
            // Execute the query and retrieve the record
            List<SObject> result = Database.query(query);
        
            return result;
        // } catch(Exception e) {
        //     throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        // }
    }

    /**
     * Retrieves all the records and their fields based on the Id param
     * 
     * @param id The Id of the object whose fields are to be retrieved
     * @return A map of all related records pertaining to the Id including that record
     */
    @AuraEnabled
    public static Map<String, List<SObject>> getRelatedAllRecords(Id id){
        try {
            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getDirectFieldsById(id) +' FROM '+ id.getSObjectType().getDescribe().getName();
            
            // Execute the query and retrieve the record
            Map<String, List<SObject>> result = new Map<String, List<SObject>>();
        
            // return [SELECT Id, Name, CloseDate, Shipping_Street__c, StageName FROM Opportunity WHERE AccountId =: id];
            return result;
        } catch(Exception e) {
            throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        }
    }

    /**
     * This method utilizes the createSObject() to create an SObject record then attempts to 
     * upsert the record into salesforce
     * 
     * @param data The data strucutre that will be deserialize and mapped into an SOject
     * @param objectType The type of SObject that we will be mapping the data to
     */
    @AuraEnabled
    public static void upsertRecord(Object data, String objectType) {
        // Create a SObject from data
        SObject record = Utility.createSObject(data, objectType);
        system.debug('record :: ' + record);
        try {
            // Attempt to upsert the SObject
            upsert record; 
        } catch(Exception e) {
            throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        }
    }

    /**
     * This method utilizes the createSObject() to create SObject records then attempts to 
     * upsert the records into salesforce
     * 
     * @param data The data strucutre that will be deserialize and mapped into an SOject
     * @param objectType The type of SObject that we will be mapping the data to
     */
    @AuraEnabled
    public static void upsertRecords(Object data, String objectType) {
        // Create a list of SObjects from data
        List<SObject> records = Utility.createSObjects(data, objectType);

        try {
            // Attempt to upsert the list of SObjects
            upsert records; 
        } catch(Exception e) {
            throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        }
    }
}