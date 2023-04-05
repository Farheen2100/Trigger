trigger CaseTrigger on Case (after insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            CaseTriggerHandler.afterInsert(Trigger.new);
        }
    }
}