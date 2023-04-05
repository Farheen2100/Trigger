public with sharing class CaseTriggerHandler {
    public static void afterInsert(List<Case> caseList) {
        CaseService.createCaseOnAccount(caseList); 
        CaseService.updateTotalPatnerAndCustomerCase(caseList);
    }
    
    
}