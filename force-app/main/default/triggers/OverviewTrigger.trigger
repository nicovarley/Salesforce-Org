trigger OverviewTrigger on Overview__c (before update) {
    OverviewTriggerHandler handler = new OverviewTriggerHandler();
    handler.execute();
}