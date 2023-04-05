public with sharing class EmployeeService {
    public static void employeeRecordDeleteUpdateAccount(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id , (SELECT Id, Account__c FROM Employees__r) FROM Account WHERE Id=: accountIds];
        for(Account acc : accounts) {
             acc.Present_Employee_Count__c = acc.Employees__r.size();
             acc.Left_Employee_Count__c = acc.Employees__r.size();
        }
        update accounts;
    }

    public static void unDeleteEmployeeRecord(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id , (SELECT Id, Account__c FROM Employees__r) FROM Account WHERE Id=: accountIds];
        for(Account acc : accounts) {
             acc.Active__c = 'yes';
             acc.Present_Employee_Count__c = acc.Employees__r.size();
             acc.Left_Employee_Count__c = acc.Employees__r.size();
        }
       update accounts;

    }
}