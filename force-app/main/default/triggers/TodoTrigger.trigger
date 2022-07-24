trigger TodoTrigger on ToDo__c (before insert, before update) {
    TodoTriggerHandler handler = new TodoTriggerHandler();
    handler.execute();
}