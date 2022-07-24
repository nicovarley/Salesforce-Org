public with sharing class SkillTriggerHandler {
    public void execute() {
        for (Skill__c skill : (List<Skill__c>)Trigger.new) {
            skill.Level__c = getLevel(skill.Experience__c);
            skill.This_Level__c = getLevelXp(skill.Level__c);
            skill.Next_Level__c = getLevelXp(skill.Level__c + 1);
            skill.Progress__c = ((skill.Experience__c - skill.This_Level__c) / (skill.Next_Level__c - skill.This_Level__c)) * 100;
            validate(skill);
        }
    }

    private void validate(Skill__c skill) {
        if (skill.Level__c < 1) {skill.Level__c.addError('Level cannot be less than 1.');}
        if (skill.Experience__c < 0) {skill.Experience__c.addError('Experience cannot be a negative.');}
    }

    private Decimal getLevel(Decimal xp) {
        Decimal lvl = 1;
        Decimal num = 0;
        while (xp >= num) {
            num += Math.floor(((lvl * lvl) + ((lvl - 1) * 5)) * 0.33049);
            lvl++;
        }
        return lvl-2;
    }
    
    private Decimal getLevelXp(Decimal lvl) {
        Decimal xp = 0;
        for (Integer i = 1; i <= lvl; i++) {
            xp += Math.floor(((i * i) + ((i - 1) * 5)) * 0.33049);
        }
        return xp;
    }
}