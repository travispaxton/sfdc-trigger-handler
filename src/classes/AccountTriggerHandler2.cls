public with sharing class AccountTriggerHandler2 extends TriggerHandler {
    public override void beforeInsert() {
        System.debug('Should run after AccountTriggerHandler');
    }
}