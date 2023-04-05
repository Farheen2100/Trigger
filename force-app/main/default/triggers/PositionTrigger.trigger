trigger PositionTrigger on Position__c (before insert) {
    if(Trigger.isBefore) {
        PositionTriggerHandler.beforeInsert(Trigger.new);
    }

}