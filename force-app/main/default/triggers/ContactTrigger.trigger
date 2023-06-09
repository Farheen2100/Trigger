trigger ContactTrigger on Contact (before insert, after insert) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            ContactTriggerHandler.afterInsert(Trigger.new);
        }
    }
}