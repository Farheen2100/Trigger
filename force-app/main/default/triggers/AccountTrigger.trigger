trigger AccountTrigger on Account (before insert,before update,before delete,after insert, after update, after delete) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            AccountHandler.beforeInsert(Trigger.new);
        }
        else if(Trigger.isUpdate) {
            AccountHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        else if(Trigger.isDelete) {
            AccountHandler.beforeDelete(Trigger.old, Trigger.oldMap);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AccountHandler.afterInsert(Trigger.new);
        }
        else if(Trigger.isUpdate) {
            AccountHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        // else if(Trigger.isDelete) {
        //     AccountHandler.afterDelete(Trigger.old);
        // }
    }

   

}