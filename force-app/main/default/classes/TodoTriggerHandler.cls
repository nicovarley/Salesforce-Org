public with sharing class TodoTriggerHandler {
    public void execute() {
        switch on Trigger.operationType {
            when BEFORE_INSERT {setFieldsBeforeInsert();}
            when BEFORE_UPDATE {setFieldsBeforeUpdate();}
        }
    }
    private void setFieldsBeforeInsert() {
        for (ToDo__c todo : (List<ToDo__c>)Trigger.new) {
            if (todo.Start__c == null) {if (todo.Status__c == 'Doing' || todo.Status__c == 'Done') {todo.Start__c = Datetime.now();}}
            if (todo.End__c == null) {if (todo.Status__c == 'Done') {todo.End__c = Datetime.now();}}
        }
    }
    private void setFieldsBeforeUpdate() {
        Map<Id,ToDo__c> old = (Map<Id,ToDo__c>)Trigger.oldMap; 
        for (ToDo__c todo : (List<ToDo__c>)Trigger.new) {
            if (old.get(todo.Id).Status__c != todo.Status__c) {
                switch on old.get(todo.Id).Status__c {
                    when 'To-Do' {
                        if (todo.Status__c == 'Doing') {todo.Start__c = Datetime.now();todo.End__c = null;}
                        if (todo.Status__c == 'Done') {todo.Start__c = Datetime.now();todo.End__c = Datetime.now();}
                    }
                    when 'Doing' {
                        if (todo.Status__c == 'To-Do') {todo.Start__c = null;todo.End__c = null;}
                        if (todo.Status__c == 'Done') {todo.End__c = Datetime.now();}
                    }
                    when 'Done' {
                        if (todo.Status__c == 'To-Do') {todo.Start__c = null;todo.End__c = null;}
                        if (todo.Status__c == 'Doing') {todo.End__c = null;}
                    }
                }
            }
        }
    }
}