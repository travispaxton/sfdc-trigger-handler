public with sharing class AccountTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        for (Account account : (List<Account>) Trigger.new) {
            System.debug(account);
        }
    }
}