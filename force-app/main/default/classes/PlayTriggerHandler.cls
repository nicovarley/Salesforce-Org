public with sharing class PlayTriggerHandler {
    OverviewChanges overviewTotal = new OverviewChanges();
    Map<Id,SkillChanges> skillTotal = new Map<Id,SkillChanges>();
    List<SObject> toUpdate = new List<SObject>();

    public void execute() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                for (Play__c play : (List<Play__c>)Trigger.new) {
                    validate(play);
                    updates(play);
                }
            }
            when AFTER_INSERT {
                for (Play__c play : (List<Play__c>)Trigger.new) {
                    addToOverview(play);
                    addToSkill(play);
                }
            }
            when BEFORE_UPDATE {
                Map<Id,Play__c> old = (Map<Id,Play__c>)Trigger.oldMap;
                for (Play__c play : (List<Play__c>)Trigger.new) {
                    validate(play, old.get(play.Id));
                    updates(play, old.get(play.Id));
                }
            }
            when AFTER_UPDATE {
                Map<Id,Play__c> old = (Map<Id,Play__c>)Trigger.oldMap;
                for (Play__c play : (List<Play__c>)Trigger.new) {
                    addToOverview(play, old.get(play.Id));
                    addToSkill(play, old.get(play.Id));
                }
            }
        }
        processUpdatesOverview();
        processUpdatesSkills();
        update toUpdate;
    }

    private void validate(Play__c play) {
        if (play.Time__c != null && (play.Start__c != null || play.Stop__c != null)) {play.Time__c.addError('Cannot specify a Time if the Start or Stop fields are populated.');}
        if (play.Start__c != null && play.Stop__c == null) {play.Stop__c.addError('Cannot insert a Play without both Start and Stop times.');}
        if (play.Stop__c != null && play.Start__c == null) {play.Start__c.addError('Cannot insert a Play without both Start and Stop times.');}
    }

    private void validate(Play__c play, Play__c old) {
        
    }

    private void updates(Play__c play) {
        if (play.Start__c != null && play.Stop__c != null) {
            Time t = Time.newInstance(play.Stop__c.hour() - play.Start__c.hour(), 
                                    play.Stop__c.minute() - play.Start__c.minute(), 
                                    play.Stop__c.second() - play.Start__c.second(), 
                                    play.Stop__c.millisecond() - play.Start__c.millisecond());
            play.Time__c = (t.hour() * 60) + t.minute(); 
        }
    }

    private void updates(Play__c play, Play__c old) {
        if (play.Start__c != old.Start__c || play.Stop__c != old.Start__c && play.Start__c != null && play.Stop__c != null) {
            Time t = Time.newInstance(play.Stop__c.hour() - play.Start__c.hour(), 
                                    play.Stop__c.minute() - play.Start__c.minute(), 
                                    play.Stop__c.second() - play.Start__c.second(), 
                                    play.Stop__c.millisecond() - play.Start__c.millisecond());
            play.Time__c = (t.hour() * 60) + t.minute(); 
        }
    }

    private void addToOverview(Play__c play) {
        if (play.Time__c != null) {
            overviewTotal.amount += play.Time__c;
        }
        if (play.Leg_Raises__c != null) {
            overviewTotal.legRaises += play.Leg_Raises__c;
        }
        if (play.Press_Ups__c != null) {
            overviewTotal.pressUps += play.Press_Ups__c;
        }
        if (play.Squats__c != null) {
            overviewTotal.squats += play.Squats__c;
        }
        if (play.Worships__c != null) {
            overviewTotal.worships += play.Worships__c;
        }
    }

    private void addToOverview(Play__c newPlay, Play__c oldPlay) {
        Decimal newValue;
        Decimal oldValue;

        if (newPlay.Time__c != null) {newValue = newPlay.Time__c;}
        else {newValue = 0;}
        if (oldPlay.Time__c != null) {oldValue = oldPlay.Time__c;}
        else {oldValue = 0;}
        overviewTotal.amount += newValue - oldValue;

        if (newPlay.Leg_Raises__c != null) {newValue = newPlay.Leg_Raises__c;}
        else {newValue = 0;}
        if (oldPlay.Leg_Raises__c != null) {oldValue = oldPlay.Leg_Raises__c;}
        else {oldValue = 0;}
        overviewTotal.legRaises += newValue - oldValue;

        if (newPlay.Press_Ups__c != null) {newValue = newPlay.Press_Ups__c;}
        else {newValue = 0;}
        if (oldPlay.Press_Ups__c != null) {oldValue = oldPlay.Press_Ups__c;}
        else {oldValue = 0;}
        overviewTotal.pressUps += newValue - oldValue;

        if (newPlay.Squats__c != null) {newValue = newPlay.Squats__c;}
        else {newValue = 0;}
        if (oldPlay.Squats__c != null) {oldValue = oldPlay.Squats__c;}
        else {oldValue = 0;}
        overviewTotal.squats += newValue - oldValue;

        if (newPlay.Worships__c != null) {newValue = newPlay.Worships__c;}
        else {newValue = 0;}
        if (oldPlay.Worships__c != null) {oldValue = oldPlay.Worships__c;}
        else {oldValue = 0;}
        overviewTotal.worships += newValue - oldValue;
    }

    private void addToSkill(Play__c play) {
        if (play.Skill__c != null) {
            addToSkillChanges(play.Skill__c, play.Time__c);
        }
    }

    private void addToSkill(Play__c newPlay, Play__c oldPlay) {
        if (newPlay.Skill__c != oldPlay.Skill__c) {
            addToSkillChanges(newPlay.Skill__c, newPlay.Time__c);
            // Using a minus to remove the value
            addToSkillChanges(oldPlay.Skill__c, -oldPlay.Time__c);
        }
        else {
            addToSkillChanges(newPlay.Skill__c, newPlay.Time__c - oldPlay.Time__c);
        }
    }

    private void addToSkillChanges(Id skillId, Decimal amount) {
        if (skillTotal.get(skillId) == null) {
            skillTotal.put(skillId, new SkillChanges(amount));
        } else {
            skillTotal.get(skillId).amount += amount;
        }
    }

    private void processUpdatesOverview() {
        Overview__c overview = [SELECT Id, Total__c, Leg_Raises__c, Press_Ups__c, Squats__c, Worships__c FROM Overview__c WITH SECURITY_ENFORCED];
        Boolean updated = false;
        if (overviewTotal.amount != 0) {
            overview.Total__c += overviewTotal.amount;
            updated = true;
        }
        if (overviewTotal.legRaises != 0) {
            overview.Leg_Raises__c += overviewTotal.legRaises;
            updated = true;
        }
        if (overviewTotal.pressUps != 0) {
            overview.Press_Ups__c += overviewTotal.pressUps;
            updated = true;
        }
        if (overviewTotal.squats != 0) {
            overview.Squats__c += overviewTotal.squats;
            updated = true;
        }
        if (overviewTotal.worships != 0) {
            overview.Worships__c += overviewTotal.worships;
            updated = true;
        }
        if (updated) {
            toUpdate.add(overview);
        }
    }

    private void processUpdatesSkills() {
        for (Skill__c skill : [SELECT Id, Experience__c FROM Skill__c WHERE Id IN :skillTotal.keySet() WITH SECURITY_ENFORCED]) {
            Boolean updated = false;
            if (skillTotal.get(skill.Id).amount != 0) {
                skill.Experience__c += skillTotal.get(skill.Id).amount;
                updated = true;
            }
            if (updated) {
                toUpdate.add(skill);
            }
        }
    }

    private class OverviewChanges {
        private Decimal amount = 0;
        private Decimal legRaises = 0;
        private Decimal pressUps = 0;
        private Decimal squats = 0;
        private Decimal worships = 0;
        private OverviewChanges() {}
        private OverviewChanges(Decimal amount) {
            this.amount = amount;
        }
    }
    
    private class SkillChanges {
        private Decimal amount = 0;
        private SkillChanges() {}
        private SkillChanges(Decimal amount) {
            this.amount = amount;
        }
    }
}