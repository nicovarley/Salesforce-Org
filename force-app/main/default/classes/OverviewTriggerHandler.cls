public with sharing class OverviewTriggerHandler {
    public void execute() {
        for (Overview__c overview : (List<Overview__c>)Trigger.new) {
            overview.Today__c = calculateToday();
            overview.Yesterday__c = calculateYesterday();
            overview.Weekly_Avg__c = calculateWeeklyAvg();
            overview.Overtime_Today__c = calculateOvertimeToday();
            overview.Overtime_Pay_Today__c = calculateOvertimeTodayPay(overview);
            overview.Overtime_This_Week__c = calculateOvertimeThisWeek();
            overview.Overtime_Pay_This_Week__c = calculateOvertimeThisWeekPay(overview);
        }
    }

    private Decimal calculateToday() {
        Decimal amount;
        try {amount = (Decimal)[SELECT SUM(Time__c) FROM Play__c WHERE CreatedDate = TODAY][0].get('expr0');}
        catch (Exception e) {}
        if (amount == null) {amount = 0;}
        return amount;
    }

    private Decimal calculateYesterday() {
        Decimal amount;
        try {amount = (Decimal)[SELECT SUM(Time__c) FROM Play__c WHERE CreatedDate = YESTERDAY][0].get('expr0');}
        catch (Exception e) {}
        if (amount == null) {amount = 0;}
        return amount;
    }

    private Decimal calculateWeeklyAvg() {
        Decimal amount;
        try {amount = (Decimal)[SELECT SUM(Time__c) FROM Play__c WHERE CreatedDate = LAST_N_DAYS:8 AND CreatedDate != TODAY][0].get('expr0') / 7;}
        catch (Exception e) {}
        if (amount == null) {amount = 0;}
        return amount;
    }

    private Decimal calculateOvertimeToday() {
        Decimal amount;
        try {amount = (Decimal)[SELECT SUM(Time__c) FROM Play__c WHERE Skill__c = 'a0A8d000006GGXmEAO' AND Date__c = TODAY][0].get('expr0');}
        catch (Exception e) {}
        if (amount == null) {amount = 0;}
        return amount;
    }

    private Decimal calculateOvertimeTodayPay(Overview__c overview) {
        return overview.Overtime_Rate__c * (overview.Overtime_Today__c / 60);
    }

    private Decimal calculateOvertimeThisWeek() {
        Decimal amount;
        try {amount = (Decimal)[SELECT SUM(Time__c) FROM Play__c WHERE Skill__c = 'a0A8d000006GGXmEAO' AND Date__c = THIS_WEEK][0].get('expr0');}
        catch (Exception e) {}
        if (amount == null) {amount = 0;}
        return amount;
    }
    
    private Decimal calculateOvertimeThisWeekPay(Overview__c overview) {
        return overview.Overtime_Rate__c * (overview.Overtime_This_Week__c / 60);
    }
}