public with sharing class CaseService {
    //scenerio - 24-March
    public static void createCaseOnAccount(List<Case> caseList) {
        list<Account> accountList  = new list<Account>();
        for(Case c : caseList) {
            Account account = new Account();
            account.Latest_Case_Number__c = c.CaseNumber;
            account.Id = c.AccountId;
            accountList.add(account);
        }
        if(!accountList.isEmpty()) {
            update accountList; 
        }
    }

    //scenerio - 22
    public static void updateTotalPatnerAndCustomerCase(List<Case> caseList) {
        List<Case> partnerCaseList = [SELECT RecordType.DeveloperName, AccountId FROM Case WHERE RecordType.DeveloperName =: 'Parent_Case'];
        List<Case> customerCaseList = [SELECT RecordType.DeveloperName, AccountId FROM Case WHERE RecordType.DeveloperName =: 'Customer_Case'];
        Map<Id, Integer> accountIdToPatnerCaseMap = new Map<Id, Integer>();
        Map<Id, Integer> accountIdToCustomerCaseMap = new Map<Id, Integer>();
        for(Case cs : partnerCaseList) {
            if(!accountIdToPatnerCaseMap.containsKey(cs.AccountId)) {
                accountIdToPatnerCaseMap.put(cs.AccountId, 0);
                }
                accountIdToPatnerCaseMap.put(cs.AccountId,accountIdToPatnerCaseMap.get(cs.AccountId)+1);
        }
        for(Case cs : customerCaseList) {
            if(!accountIdToCustomerCaseMap.containsKey(cs.AccountId)) {
                accountIdToCustomerCaseMap.put(cs.AccountId, 0);
                }
                accountIdToCustomerCaseMap.put(cs.AccountId,accountIdToCustomerCaseMap.get(cs.AccountId)+1);
        }
        List<Account> accounts = new List<Account>();
        for(Account acc : [SELECT Id FROM Account WHERE Id =: accountIdToPatnerCaseMap.keySet() OR Id =: accountIdToCustomerCaseMap.keySet()]) {
            Account account = new Account();
            acc.Total_Customer_Case__c = accountIdToCustomerCaseMap.get(acc.Id);
            acc.Total_Partner_Case__c = accountIdToPatnerCaseMap.get(acc.Id);
            account.Id = acc.Id;
            accounts.add(acc);
        }
        if(!accounts.isEmpty()) {
            update accounts;
        }
    }
}