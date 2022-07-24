public with sharing class IncomingTriggerHandler {
    public void execute() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {beforeInsert();}
            when AFTER_INSERT {afterInsert();}
            when BEFORE_UPDATE {beforeUpdate();}
            when AFTER_UPDATE {afterUpdate();}
        }
    }

    private void beforeInsert() {
        for (Income__c inc : (List<Income__c>)Trigger.new) {
            validate();
        }
    }

    private void afterInsert() {
        Set<Id> treasuryIds = new Set<Id>();
        for (Income__c inc : (List<Income__c>)Trigger.new) {
            if (inc.Treasury__c != null) {treasuryIds.add(inc.Treasury__c);}
        }
        Map<Id,Treasury__c> treasuries = new Map<Id,Treasury__c>([SELECT Id, Amount__c FROM Treasury__c WHERE Id IN :treasuryIds WITH SECURITY_ENFORCED]);
        for (Income__c inc : (List<Income__c>)Trigger.new) {
            if (inc.Treasury__c == null) {continue;}
            treasuries.get(inc.Treasury__c).Amount__c += inc.Amount__c;
        }
        update treasuries.values();
    }

    private void beforeUpdate() {
        for (Income__c inc : (List<Income__c>)Trigger.new) {
            validate();
        }
    }

    private void afterUpdate() {
        Set<Id> treasuryIds = new Set<Id>();
        Map<Id,Income__c> old = (Map<Id,Income__c>)Trigger.oldMap;
        for (Income__c inc : (List<Income__c>)Trigger.new) {
            if (inc.Treasury__c != null) {treasuryIds.add(inc.Treasury__c);}
            if (old.get(inc.Id).Treasury__c != null) {treasuryIds.add(old.get(inc.Id).Treasury__c);}
        }
        Map<Id,Treasury__c> treasuries = new Map<Id,Treasury__c>([SELECT Id, Amount__c FROM Treasury__c WHERE Id IN :treasuryIds WITH SECURITY_ENFORCED]);
        for (Income__c inc : (List<Income__c>)Trigger.new) {
            if (inc.Treasury__c != null) {
                treasuries.get(inc.Treasury__c).Amount__c += inc.Amount__c;
            }
            if (old.get(inc.Id).Treasury__c != null) {
                treasuries.get(old.get(inc.Id).Treasury__c).Amount__c -= old.get(inc.Id).Amount__c;
            }
        }
        update treasuries.values();
    }

    private void validate() {
        for (Income__c inc : (List<Income__c>) Trigger.new) {
            if (inc.Amount__c < 0) {inc.Amount__c.addError('Amount cannot be negative.');}
        }
    }
}