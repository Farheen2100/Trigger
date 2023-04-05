public with sharing class PositionTriggerHandler {
    public static void beforeInsert(List<Position__c> positions) {
        populateFieldWhenNewPositionCreate(positions);
    }
    
    public static void populateFieldWhenNewPositionCreate(List<Position__c> positions) {
        for(Position__c position: positions) {
                position.Open_Dtae__c = Date.today();
                position.Max_Pay__c = 15000;
                position.Mn_Pay__c = 10000;
        }
    }
}