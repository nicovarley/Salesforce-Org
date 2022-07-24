trigger SkillTrigger on Skill__c (before insert, before update) {
    SkillTriggerHandler handler = new SkillTriggerHandler();
    handler.execute();
}