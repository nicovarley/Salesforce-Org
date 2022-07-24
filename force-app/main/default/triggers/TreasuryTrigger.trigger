trigger TreasuryTrigger on Treasury__c (before insert, after insert, before update, after update) {
    TreasuryTriggerHandler handler = new TreasuryTriggerHandler();
    handler.execute();
}