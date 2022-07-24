trigger IncomingTrigger on Income__c (before insert, after insert, before update, after update) {
    IncomingTriggerHandler handler = new IncomingTriggerHandler();
    handler.execute();
}