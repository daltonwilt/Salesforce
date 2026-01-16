/**
 * A utility class to call builder profile for screen to render Lightning Web
 * Components dynamically.
 * 
 * @author            : dalton@outlook.com
 * @last modified on  : 9/15/2025
 * @last modified by  : dalton@outlook.com
 * @todo
 */
public with sharing class BuilderService {
    public BuilderService() {}

    @AuraEnabled
    public static Builder__c getBuilder(){
        try {
            Builder__c builder = [
                SELECT Id, Name,
                    (SELECT Id, Name, Order__c,
                            (SELECT Id, Name, Order__c, Height__c,
                                    (SELECT Id, Name, Order__c, Width__c,
                                        (SELECT Id, Name, Order__c, Style__c, Builder_Component__r.Component__c, Builder_Component__r.Style__c
                                            FROM Builder_Contents__r)
                                        FROM Builder_Columns__r)
                                FROM Builder_Rows__r)
                        FROM Builder_Pages__r)
                FROM Builder__c 
            LIMIT 1];
            return builder;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Builder_Component__c> getBuilderComponents(){
        try {
            List<Builder_Component__c> components = [
                    SELECT Id, Name, Component__c, Import_Constructor__c, Style__c, Type__c
                    FROM Builder_Component__c
                ];
            return components;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
