public with sharing class EmployeeTriggerHandler {
   
    public static void afterDelete(List<Employee__c> employees) {
        employeeRecordDeleteUpdateAccount(employees);
    }
    public static void afterUnDelete(List<Employee__c> employees) {
        unDeleteEmployeeRecord(employees);
    }

    //scenerio -17 and 20
    public static void employeeRecordDeleteUpdateAccount(List<Employee__c> employees) {
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employees) {
            accountIds.add(employee.Account__c);
        }
        EmployeeService.employeeRecordDeleteUpdateAccount(accountIds);
    }

    //scenerio - 18,19
    public static void unDeleteEmployeeRecord(List<Employee__c> employees) {
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : employees) {
            accountIds.add(employee.Account__c);
        }
        EmployeeService.unDeleteEmployeeRecord(accountIds);
    }
}