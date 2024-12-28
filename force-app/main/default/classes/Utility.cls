/**
 * @description       : Utility worker methods for the Generic generilzation methods
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
public without sharing class Utility {
    public class DateException extends Exception {}

    /**
     * This method creates a SObject record of the type passed into the param that hasn't
     * deserialized the data
     * 
     * @param mRecord The record that is being mapped out
     * @param objectType
     * @param approvedPLMap the list of approved product lines mapped by Equipment Request
     * @return A SObject record that is of the type passed into param
     */
    @AuraEnabled
    public static SObject createSObject(Object data, String objectType){
        // Map record from JS Object to Case Object type schema structure
        Map<String, Object> mRecord = deserializeRecord(data);

        // Create a SObject based off deserialized record
        SObject record = createSObjectDeserialized(mRecord, objectType);

        return record;
    }

    /**
     * This method creates a SObject record of the type passed into the param that already
     * has deserialized the data
     * 
     * @param mRecord The record that is being mapped out
     * @param objectType
     * @param approvedPLMap the list of approved product lines mapped by Equipment Request
     * @return A SObject record that is of the type passed into param
     */
    public static SObject createSObjectDeserialized(Map<String, Object> mRecord, String objectType) {
        Map<String, Schema.SObjectField> fm = getDescribeFields(objectType);

        SObject record = Schema.getGlobalDescribe().get(objectType).newSObject();
        for(String key : mRecord.keySet()) {
            if(key == 'attributes' || mRecord.get(key) == null)
                continue;

            Schema.DescribeFieldResult fieldResult = fm.get(key.toLowerCase().trim()).getDescribe();

            String type = fm.get(key.toLowerCase().trim()).getDescribe().getType().name();
            Object value = formatValue(type, String.valueOf(mRecord.get(key)));

            if(fieldResult.isCreateable())
                record.put(key, value);
        }

        return record;
    }

    /**
     * This method utilizes the createSObject() method in order to create a
     * list of SObject records of the type pass into the param that hasn't
     * deserialized the data
     * 
     * @param oRecords The record that is being mapped out
     * @param objectType
     * @param approvedPLMap the list of approved product lines mapped by Equipment Request
     * @return A list of SObject records that are of the type passed into param
     */
    @AuraEnabled
    public static List<SObject> createSObjects(Object data, String objectType){
        // Deserialize data into a list of mapped records
        List<Map<String,Object>> mRecords = deserializeRecords(data);

        // Create a list of SObjects based off deserialized data
        List<SObject> records = createSObjectsDeserialized(mRecords, objectType);

        return records;
    }

    /**
     * This method utilizes the createSObject() method in order to create a
     * list of SObject records of the type pass into the param that has
     * deserialized the data
     * 
     * @param oRecords The record that is being mapped out
     * @param objectType
     * @param approvedPLMap the list of approved product lines mapped by Equipment Request
     * @return A list of SObject records that are of the type passed into param
     */
    @AuraEnabled
    public static List<SObject> createSObjectsDeserialized(List<Map<String,Object>> mRecords, String objectType) {
        List<SObject> records = new List<SObject>();

        for(Object mRecord : mRecords) {
            SObject record = createSObject(mRecord, objectType);
            records.add(record);
        }

        return records;
    }

    /**
     * This method deserializes a JS Object record into a mapped record of key <> value pair
     * 
     * @param record The record that is being mapped out from a JS Object type
     * @param approvedPLMap the list of approved product lines mapped by Equipment Request
     * @return A list of Equipment Requests
     */
    public static Map<String, Object> deserializeRecord(Object record) {
        String sJson = JSON.serialize(record);
        Object oRecord = (Object) JSON.deserializeUntyped(sJson);
        return (Map<String, Object>) oRecord;
    }

    /**
     * This method deserializes a JS Object into a list of Objects. Utilized for an Object that contains
     * a list of records sent from JS
     * 
     * @param record The list of records to be deserialized from a JS Object type
     * @param approvedPLMap the list of approved product lines mapped by Equipment Request
     * @return A list of Equipment Requests
     */
    public static List<Map<String,Object>> deserializeRecords(Object record) {
        List<Map<String,Object>> mRecords = new List<Map<String,Object>>();

        String sJson = JSON.serialize(record);
        List<Object> oRecords = (List<Object>)JSON.deserializeUntyped(sJson);
        for(Object oRecord : oRecords) {
            Map<String,Object> mRecord = (Map<String,Object>)oRecord;
            mRecords.add(mRecord);
        }

        return mRecords;
    }

    /**
     * Retrieve the schema describe for object related to the object type provided
     * 
     * @param objectType That we are retrieving schema fields
     * @return Map of schema describe for object type
     */
    public static Schema.SObjectType getDescribeObjectType(String objectType) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        return gd.get(objectType);
    }

    /**
     * Retrieve the schema describe result for objects related to the object type provided
     * 
     * @param objectType That we are retrieving schema fields
     * @return Map of schema describe result for object type
     */
    public static Schema.DescribeSObjectResult getDescribeObjectResult(String objectType) {
        Schema.SObjectType obj = getDescribeObjectType(objectType);
        return obj.getDescribe();
    }

    /**
     * Retrieve the schema describe fields for objects related to the object type provided
     * 
     * @param objectType That we are retrieving schema fields
     * @return Map of schema describe for fields related to the object type
     */
    public static Map<String, Schema.SObjectField> getDescribeFields(String objectType) {
        Schema.SObjectType obj = getDescribeObjectType(objectType);
        return obj.getDescribe().fields.getMap();
    }

        /**
     * This method is used for gathering all direct readable field API names from an SObject a string to pass
     * as into a Dynamic Query
     * 
     * @param id of SObject that we want to query all field API names for
     * @param rFields List of reference fields that we want to query for\
     * @return A formatted string of comma separated API Names for the passed param
     */
    public static String getFieldsById(Id id, list<String> rFields) {
        String objectType = id.getSObjectType().getDescribe().getName();

        // Get all the fields for the SObject
        Map<String, Schema.SObjectField> fields = getDescribeFields(objectType);
        String fFields = formatFields(fields);

        if(!rFields.isEmpty())
            fFields += ', ' + getReferenceFields(objectType, rFields);

        return fFields;
    }


    /**
     * This method is used for gathering all readable field API names from an SObject a string to pass
     * as into a Dynamic Query
     * 
     * @param objectType Type of SObject that we want to query all field API names for
    * @param rFields List of reference fields that we want to query for
     * @return A formatted string of comma separated API Names for the passed param
     */
    public static String getFieldsByType(String objectType, list<String> rFields) {
        // Get all the fields for the SObject
        Map<String, Schema.SObjectField> fields = getDescribeFields(objectType);
        String fFields = formatFields(fields);

        if(!rFields.isEmpty())
            fFields += ', ' + getReferenceFields(objectType, rFields);
        
        return fFields;
    }

    /**
     * This method is used for gathering all readable field API names from an SObject a string to pass
     * as into a Dynamic Query including the reference relationship fields
     * 
     * @param objectType Type of SObject that we want to query all field API names for
     * @param rFields List of reference fields that we want to query for
     * @return A formatted string of comma separated API Names for the passed param
     * @TODO:
     * - break this down into worker methods
     */
    public static String getReferenceFields(String objectType, list<String> rFields) {
        // Get all the fields for the SObject
        Map<String, Schema.SObjectField> fields = getDescribeFields(objectType);
        
        // List to store field names
        List<String> fieldNames = new List<String>();
    
        // Iterate through the fields
        for (String fieldName : fields.keySet()) {
            if(!rFields.contains(fieldName)) continue;

            Schema.DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
    
            // Check if the field is a lookup/reference field
            if (fieldDescribe.getType() == Schema.DisplayType.Reference) {
                // Get the referenced/parent object types (there could be multiple, such as with polymorphic lookups)
                List<Schema.SObjectType> referenceTo = fieldDescribe.getReferenceTo();
                
                // Iterate over the referenced objects
                for (Schema.SObjectType parentObject : referenceTo) {
                    // Get the fields from the parent object
                    Map<String, Schema.SObjectField> parentFields = getDescribeFields(parentObject.getDescribe().getName());
                    
                    // Add the parent fields with the proper notation (e.g., Parent__r.FieldName)
                    for (String parentFieldName : parentFields.keySet()) {
                        Schema.DescribeFieldResult parentFieldDescribe = parentFields.get(parentFieldName).getDescribe();
                        String referenceName = fieldDescribe.getName().substring(0, fieldDescribe.getName().length() - 1) + 'r';
                        fieldNames.add(referenceName + '.' + parentFieldDescribe.getName());
                    }
                }
            }
        }
    
        return String.join(fieldNames, ', ');
    }

    /**
     * This method is used for formatting a map of Schema.SObjectFields into a string
     * with comma separated delimiters
     * 
     * @param fields The fields that will be formatted
     * @return A formated value of fields from the map that was passed in
     */
    public static String formatFields(Map<String, Schema.SObjectField> fields) {
        // List to store field names
        List<String> fieldNames = new List<String>();

        // Iterate through the fields and print the field names
        for (String fieldName : fields.keySet()) {            
            // Add the field name to the list
            fieldNames.add(fieldName);
        }

        // Join the field names into a comma-separated string
        String fieldList = String.join(fieldNames, ', ');
        return fieldList;
    }

    /**
     * This method is used for formatting data into the correct data type in order to be
     * entered into Salesforce records
     * 
     * @param type The type for object field values
     * @param value The value to be formatted
     * @return A formated value according to the data type from the Object settings
     */
    public static Object formatValue(String type, String value){
        if (String.isBlank(value)) return null;
        if(value == null) return value;

        value = value.trim();
        if(type == 'CURRENCY' || type == 'DOUBLE' || type == 'PERCENT') {
            string tempVal = value.replaceAll('[$,]', '');
            string numVal = tempVal.replaceAll('[^0-9.-]', '');
            if(numVal.length() == 0)
                return null;
            return Decimal.valueOf(numVal);
        } else if (type == 'BOOLEAN'){
            return Boolean.valueOf(value);
        } else if (Type == 'DATE') {
            try {
                List<String> strParts = value.split(' ');
                strParts = strParts[0].split('/');
                if (strParts.size() == 1) {
                    strParts = value.split('-');
                    return Date.newInstance(Integer.valueOf(strParts[0]), Integer.valueOf(strParts[1]), Integer.valueOf(strParts[2]));
                } else {
                    return Date.newInstance(Integer.valueOf(strParts[2]), Integer.valueOf(strParts[0]), Integer.valueOf(strParts[1]));
                }
            } catch (Exception e){
                throw new DateException('Unable to Convert into Correct DATE Format');
            }
        }
        
        return value;
    }

}
