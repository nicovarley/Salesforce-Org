public with sharing class TreasuryTriggerHandler {
    private List<Treasury__c> treasuries = [SELECT Id, Name, Amount__c, Total__c FROM Treasury__c WHERE OwnerId = :UserInfo.getUserId() WITH SECURITY_ENFORCED];
    private Decimal total = (Decimal)[SELECT SUM(Amount__c) FROM Treasury__c WHERE OwnerId = :UserInfo.getUserId() WITH SECURITY_ENFORCED][0].get('expr0');
    private Map<Id,Treasury__c> toUpdate = new Map<Id,Treasury__c>();
    private Boolean updates = false;

    public void execute() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {validate();}
            when AFTER_INSERT {updateFields(); if (updates) {update toUpdate.values(); updates = false;}}
            when BEFORE_UPDATE {validate();}
            when AFTER_UPDATE {updateFields(); if (updates) {update toUpdate.values(); updates = false;}}
        }
    }

    private void validate() {
        
    }

    private void updateFields() {
        for (Treasury__c t : treasuries) {
            if (toUpdate.get(t.Id) == null) {
                if (t.Total__c != total) {t.Total__c = total;toUpdate.put(t.Id, t);updates = true;}
            }
            else {
                if (toUpdate.get(t.Id).Total__c != total) {toUpdate.get(t.Id).Total__c = total;updates = true;}
            }
        }
    }
}