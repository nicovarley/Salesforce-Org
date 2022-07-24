trigger OutgoingTrigger on Outgoing__c (before insert, after insert, before update, after update) {
    OutgoingTriggerHandler handler = new OutgoingTriggerHandler();
    handler.execute();
}