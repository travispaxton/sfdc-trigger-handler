public with sharing class ContactTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        System.debug(Trigger.new);
    }
}