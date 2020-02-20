public virtual class TriggerHandler {
    private static Map<String, List<String>> triggerHandlers = new Map<String, List<String>>();

    static {
        for (TriggerHandler__mdt triggerHandler : [SELECT MasterLabel, QualifiedApiName, Object__c FROM TriggerHandler__mdt WHERE Active__c = true ORDER BY Order__c]) {
            List<String> classNames = triggerHandlers.containsKey(triggerHandler.Object__c) ? triggerHandlers.get(triggerHandler.Object__c) : new List<String>();
            classNames.add(triggerHandler.QualifiedApiName);
            triggerHandlers.put(triggerHandler.Object__c, classNames);
        }
    }

    public static void handleTrigger(List<SObject> workingRecords, List<SObject> oldRecords, System.TriggerOperation triggerEvent) {
        String sObjectType = workingRecords[0].getSObjectType().getDescribe().getName();
        if (triggerHandlers.containsKey(sObjectType)) {
            List<String> classNames = triggerHandlers.get(sObjectType);
            for (String className : classNames) {
                Type classType = Type.forName(className);
                if (classType != null) {
                    for (SObject workingRecord : workingRecords) {
                        TriggerHandler triggerHandler = (TriggerHandler) classType.newInstance();
                        switch on triggerEvent {
                            when BEFORE_INSERT {
                                triggerHandler.beforeInsert();
                            }
                            when AFTER_INSERT {
                                triggerHandler.afterInsert();
                            }
                            when BEFORE_UPDATE {
                                triggerHandler.beforeUpdate();
                            }
                            when AFTER_UPDATE {
                                triggerHandler.afterUpdate();
                            }
                            when BEFORE_DELETE {
                                triggerHandler.beforeDelete();
                            }
                            when AFTER_DELETE {
                                triggerHandler.afterDelete();
                            }
                            when AFTER_UNDELETE {
                                triggerHandler.afterUndelete();
                            }
                        }
                    }
                }
            }
        }
    }

    protected virtual void beforeInsert() {}
    protected virtual void afterInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void afterUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}
}