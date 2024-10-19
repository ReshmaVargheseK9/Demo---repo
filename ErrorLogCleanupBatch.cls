/**
* @description  Error log cleanup batch to delete error object (Error__c) records and keep only the last 60 days on the Salesforce
*
*/           
global class ErrorLogCleanupBatch implements Database.Batchable<SObject>, schedulable  {
    
    String query;
    String queryName;
    
    global ErrorLogCleanupBatch(String queryName){ 
        this.queryName = queryName;    
        Query__c queryRecord = [SELECT Id, SOQL__c FROM Query__c WHERE Name = :queryName LIMIT 1];
        if(queryRecord != NULL){
            this.query = queryRecord.SOQL__c;
        }  
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {   
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope){
        try {
            List<Database.DeleteResult> results = Database.Delete(scope, false);
        } catch(Exception e) {
        }
    }
    global void finish(Database.BatchableContext bc) { 
        
    }
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new ErrorLogCleanupBatch(queryName),2000);
    }
}
