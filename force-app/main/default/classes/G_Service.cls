/**
 * A service class for generic use case apex methods.
 * 
 * @author            : dalton@outlook.com
 * @last modified on  : 9/15/2025
 * @last modified by  : dalton@outlook.com
 * @todo
 *   - Implement logging of HTTP requests and responses.
 */
public without sharing class G_Service {
    public Service() {}

    /**
     * Retrieves all the records pertaining to search criteria
     * 
     * @param objectType
     * @param fields
     * @param term
     * @return A list of records pertaining to search criteria
     */
    @AuraEnabled
    public static List<Customer__c> search(String objectType, Object searchConfig, List<String> rFields) {
        // try {
            Map<String, Object> config = Utility.deserializeRecord(searchConfig);

            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getFieldsByType(objectType, rFields) +' FROM '+ objectType;

            List<String> conditions = new List<String>();

            // Append conditions if values are provided
            for(String key : config.keySet())
                conditions.add(key + '=\'' + String.escapeSingleQuotes((String) config.get(key)) + '\'');

            // Add the WHERE clause if there are conditions
            if (!conditions.isEmpty()) query += ' WHERE ' + String.join(conditions, ' OR ');

            // Debug the final query
            System.debug('query >> ' + query);

            // Execute the query
            return Database.query(query);
        // } catch(Exception e) {
        //     throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        // }
    }

    /**
     * Retrieves all the records pertaining to search term
     * 
     * @param term
     * @return A list of records
     */
    @AuraEnabled
    public static List<List<SObject>> searchSOSL(String term){
        try {
            String query = 'FIND \'*' +term+ '*\' IN Name, Email__c, Phone__c Fields RETURNING dms_Customer__c';
            return search.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Retrieves all the records pertaining to lookup criteria
     * 
     * @param objectType
     * @param fields
     * @param term
     * @return A list of records pertaining to lookup criteria
     */
    @AuraEnabled
    public static List<SObject> lookup(String objectType, List<String> fields, String term){
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
     * @param objectType
     * @param fields
     * @return A map of field keys to their list of picklist values
     */
    @AuraEnabled
    public static map<String, list<map<String, String>>> getPiclistValues(String objectType, list<String> fields){
        map<String, list<map<String, String>>> picklistValuesByField = new map<String, list<map<String, String>>>();

        // try {
            // Get the object type
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectType);
            Schema.DescribeSObjectResult describeSObjectResult = sObjectType.getDescribe();
            
            for(String field : fields) {
                list<map<String, String>> picklistValues = new list<map<String, String>>();

                // Get the field details
                Schema.DescribeFieldResult describeFieldResult = describeSObjectResult.fields.getMap().get(field).getDescribe();
                
                // Retrieve picklist values for the specified record type
                for (Schema.PicklistEntry picklistEntry : describeFieldResult.getPicklistValues()) {
                    // Filter values based on record type ID
                    picklistValues.add(new map<String, String>{
                        picklistEntry.getLabel() => picklistEntry.getValue()
                    });
                }

                picklistValuesByField.put(field, picklistValues);
            }
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }

        return picklistValuesByField;
    }

    /**
     * Retrieves all record types of a given object type
     * 
     * @param objectType
     * @return A map of record type IDs to names
     */
    @AuraEnabled
    public static Map<String, String> getRecordTypes(String objectType) {
        Map<String, String> recordTypes = new Map<String, String>();

        // Get the SObjectType
        Schema.DescribeSObjectResult r = Schema.getGlobalDescribe().get(objectType).getDescribe();
        // Retrieve RecordType info
        Map<String, Schema.RecordTypeInfo> recordTypeMap = r.getRecordTypeInfosByName();

        // Iterate through the map to get RecordType data
        for (Schema.RecordTypeInfo recordType : recordTypeMap.values()) {
            if(recordType.active)
                recordTypes.put(recordType.getName(), String.valueOf(recordType.getRecordTypeId()));
        }

        return recordTypes;
    }

    /**
     * Retrieves all the records and their fields based on the Id param
     * 
     * @param id The Id of the object whose fields are to be retrieved
     * @return A list of records pertaining to the Id
     */
    @AuraEnabled
    public static List<SObject> getRecords(Id id, Id parentId, String filter){
        // try {
            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getFieldsById(id, null) +' FROM '+ id.getSObjectType().getDescribe().getName() +' WHERE '+ filter;
            
            // Execute the query and retrieve the record
            List<SObject> result = Database.query(query);
        
            // return [SELECT Id, Name, CloseDate, Shipping_Street__c, StageName FROM Opportunity WHERE AccountId =: id];
            return result;
        // } catch(Exception e) {
        //     throw new AuraHandledException('Stacktrace :: ' + e.getStackTraceString() + ' <> ' + 'Message :: ' + e.getMessage());
        // }
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
            String query = 'SELECT '+ Utility.getFieldsById(id, null) +' FROM '+ id.getSObjectType().getDescribe().getName();
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
            String query = 'SELECT '+ Utility.getFieldsById(id, null) +' FROM '+ id.getSObjectType().getDescribe().getName();
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
    public static SObject getRecordByType(String objectType, Object configFilter, String orderBy, List<String> rFields){
        // try {
            Map<String, Object> config = Utility.deserializeRecord(configFilter);

            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getFieldsByType(objectType, rFields) +' FROM '+ objectType;

            if(configFilter != null) {
                List<String> conditions = new List<String>();
                for(String key : config.keySet())
                    conditions.add(key + '=\'' + String.escapeSingleQuotes((String) config.get(key)) + '\'');

                if (!conditions.isEmpty()) query += ' WHERE ' + String.join(conditions, ' AND ');
            }
            if(orderBy != null) query += ' ORDER BY '+ orderBy;
            query = query + ' LIMIT 1';

            // Execute the query and retrieve the record
            return Database.query(query);
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
    public static List<SObject> getRecordsByType(String objectType, Object configFilter, String orderBy, List<String> rFields){
        // try {
            Map<String, Object> config = Utility.deserializeRecord(configFilter);

            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getFieldsByType(objectType, rFields) +' FROM '+ objectType;

            if(configFilter != null) {
                List<String> conditions = new List<String>();
                for(String key : config.keySet())
                    conditions.add(key + '=\'' + String.escapeSingleQuotes((String) config.get(key)) + '\'');

                if (!conditions.isEmpty()) query += ' WHERE ' + String.join(conditions, ' AND ');
            }
            if(orderBy != null) query += ' ORDER BY '+ orderBy;
            
            // Execute the query and retrieve the record
            return Database.query(query);
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
     * @return A map of all related records pertaining to the Id including that record
     */
    @AuraEnabled
    public static Map<String, List<SObject>> getRelatedAllRecords(Id id){
        try {
            // Dynamically build a SOQL query to retrieve all fields
            String query = 'SELECT '+ Utility.getFieldsById(id, null) +' FROM '+ id.getSObjectType().getDescribe().getName();
            
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
