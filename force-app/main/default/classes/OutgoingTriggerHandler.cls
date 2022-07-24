public with sharing class OutgoingTriggerHandler {
    public void execute() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {beforeInsert();}
            when AFTER_INSERT {afterInsert();}
            when BEFORE_UPDATE {beforeUpdate();}
            when AFTER_UPDATE {afterUpdate();}
        }
    }

    private void beforeInsert() {
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            validate();
        }
    }

    private void afterInsert() {
        Set<Id> treasuryIds = new Set<Id>();
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            if (out.Treasury__c != null) {treasuryIds.add(out.Treasury__c);}
        }
        Map<Id,Treasury__c> treasuries = new Map<Id,Treasury__c>([SELECT Id, Amount__c FROM Treasury__c WHERE Id IN :treasuryIds WITH SECURITY_ENFORCED]);
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            if (out.Treasury__c == null) {continue;}
            treasuries.get(out.Treasury__c).Amount__c -= out.Amount__c;
        }
        update treasuries.values();
    }

    private void beforeUpdate() {
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            validate();
        }
    }

    private void afterUpdate() {
        Set<Id> treasuryIds = new Set<Id>();
        Map<Id,Outgoing__c> old = (Map<Id,Outgoing__c>)Trigger.oldMap;
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            if (out.Treasury__c != null) {treasuryIds.add(out.Treasury__c);}
            if (old.get(out.Id).Treasury__c != null) {treasuryIds.add(old.get(out.Id).Treasury__c);}
        }
        Map<Id,Treasury__c> treasuries = new Map<Id,Treasury__c>([SELECT Id, Amount__c FROM Treasury__c WHERE Id IN :treasuryIds WITH SECURITY_ENFORCED]);
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            if (out.Treasury__c != null) {
                treasuries.get(out.Treasury__c).Amount__c -= out.Amount__c;
            }
            if (old.get(out.Id).Treasury__c != null) {
                treasuries.get(old.get(out.Id).Treasury__c).Amount__c += old.get(out.Id).Amount__c;
            }
        }
        update treasuries.values();
    }

    private void validate() {
        for (Outgoing__c out : (List<Outgoing__c>)Trigger.new) {
            if (out.Amount__c < 0) {out.Amount__c.addError('Amount cannot be negative.');}
        }
    }
}