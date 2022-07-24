@IsTest
private class PlayTriggerTest {
    @TestSetup
    static void makeData() {
        insert new Overview__c(Name = 'Test');
        insert new Skill__c(Name = 'Skill 1');
        insert new Skill__c(Name = 'Skill 2');
    }

    @IsTest
    static void insertPlayWithSkill() {
        Skill__c skill1 = [SELECT Id FROM Skill__c WHERE Name = 'Skill 1'][0];
        insert new Play__c(Time__c = 1, Skill__c = skill1.Id);
        
        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(1.0, skill1.Experience__c);
    }

    @IsTest
    static void insertPlayWithoutSkill() {
        insert new Play__c(Time__c = 1);
        
        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        Skill__c skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(0.0, skill1.Experience__c);
    }

    @IsTest
    static void updatePlayAddSkill() {
        insert new Play__c(Time__c = 1);

        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        Skill__c skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(0.0, skill1.Experience__c);

        Play__c play = [SELECT Id FROM Play__c][0];
        play.Skill__c = skill1.Id;
        update play;

        overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(1.0, skill1.Experience__c);
    }

    @IsTest
    static void updatePlayRemoveSkill() {
        Skill__c skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        insert new Play__c(Time__c = 1, Skill__c = skill1.Id);
        
        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(1.0, skill1.Experience__c);

        
        Play__c play = [SELECT Id FROM Play__c][0];
        play.Skill__c = null;
        update play;

        overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(0.0, skill1.Experience__c);
    }

    @IsTest
    static void updatePlayChangeSkill() {
        Skill__c skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        insert new Play__c(Time__c = 1, Skill__c = skill1.Id);
        
        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(1.0, skill1.Experience__c);

        Skill__c skill2 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 2'][0];
        Play__c play = [SELECT Id FROM Play__c][0];
        play.Skill__c = skill2.Id;
        update play;

        overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        skill2 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 2'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(0.0, skill1.Experience__c);
        System.assertEquals(1.0, skill2.Experience__c);
    }

    @IsTest
    static void updatePlayAddTime() {
        Skill__c skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        insert new Play__c(Time__c = 1, Skill__c = skill1.Id);

        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(1.0, skill1.Experience__c);

        Play__c play = [SELECT Id FROM Play__c][0];
        play.Time__c = 5;
        update play;

        overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(5.0, overview.Total__c);
        System.assertEquals(5.0, skill1.Experience__c);
    }
    
    @IsTest
    static void updatePlayRemoveTime() {
        Skill__c skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        insert new Play__c(Time__c = 5, Skill__c = skill1.Id);

        Overview__c overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(5.0, overview.Total__c);
        System.assertEquals(5.0, skill1.Experience__c);

        Play__c play = [SELECT Id FROM Play__c][0];
        play.Time__c = 1;
        update play;

        overview = [SELECT Id, Total__c FROM Overview__c][0];
        skill1 = [SELECT Id, Experience__c FROM Skill__c WHERE Name = 'Skill 1'][0];
        System.assertEquals(1.0, overview.Total__c);
        System.assertEquals(1.0, skill1.Experience__c);
    }
}