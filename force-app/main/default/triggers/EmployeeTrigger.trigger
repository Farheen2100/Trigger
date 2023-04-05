trigger EmployeeTrigger on Employee__c (before insert, after delete, after undelete) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            EmployeeTriggerHandler.beforeInsert(Trigger.new);
        }
    }

    if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            EmployeeTriggerHandler.afterDelete(Trigger.old);
        }
        else if(Trigger.isUndelete) {
            EmployeeTriggerHandler.afterUnDelete(Trigger.new);
        }
    }

}