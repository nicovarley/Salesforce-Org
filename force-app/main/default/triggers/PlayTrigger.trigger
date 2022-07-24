trigger PlayTrigger on Play__c (before insert, after insert, before update, after update) {
    PlayTriggerHandler handler = new PlayTriggerHandler();
    handler.execute();
}