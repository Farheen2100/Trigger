public with sharing class OpportunityTriggerHandler {
    public static void beforeInsert(List<Opportunity> opportunities) {
        populateDescriptionField(opportunities);
        updateOpportunityStage(opportunities);
    }

    public static void beforeUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap ) {
        updateStageToClosedLost(opportunities, opportunityMap);
        updateStageToClosedLostOrWon(opportunities, opportunityMap);
    }
    
    public static void beforeDelete(List<Opportunity> opportunities) {
        opportunityDeleteBySystemAdminstrator(opportunities);
    }

    public static void afterInsert(List<Opportunity> opportunities ) {
        OpportunityService.PopulateOpportunityAmountOnAccount(opportunities);
        updateAccountAnnualRevenue(opportunities);
    
    }

    public static void afterUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap ) {
        OpportunityService.createTaskOnOpportunity(opportunities,opportunityMap);
        updateAccountAnnualRevenue(opportunities);
    }

    public static void afterDelete(List<Opportunity> opportunities) {
        updateAccountAnnualRevenue(opportunities);
    }
    
    // -2 23-March 
    public static void populateDescriptionField(List<Opportunity> opportunities) {
        for(Opportunity opportunity: opportunities) {
            if(opportunity.Amount > 100000  && opportunity.Amount != NULL) {
                opportunity.Description = 'Hot Opportunity’';
            }
        }
    }
    // scenerio - 2
    public static void updateOpportunityStage(List<Opportunity> opportunities) {
         for(Opportunity opp : opportunities){
            if(opp.StageName == 'Closed Lost'){
                opp.Description = 'Opportunity is Closed Lost';
            }
            else if(opp.StageName == 'Closed Won'){
                opp.Description = 'Opportunity is Closed Won';
            }
            else {
                opp.Description = 'Opportunity is Open';
            }
        }
    }

    //scenerio - 12
    public static void updateStageToClosedLost(List<Opportunity> opportunities, Map<Id,Opportunity> opportunityMap ) {
        for(Opportunity opportunity : opportunities) {
            if(opportunity.StageName == 'Closed Lost' && opportunity.StageName != opportunityMap.get(opportunity.Id).StageName && opportunity.Closed_Lost_Reason__c == NULL) {
                opportunity.Closed_Lost_Reason__c.addError('Please populate Closed Lost Reason');
            }
        }
    }

    //scenerio - 14
    private static void opportunityDeleteBySystemAdminstrator(List<Opportunity> opportunities) {
        Id profileId = UserInfo.getProfileId();
        Profile profileName = [SELECT Name,Id FROM Profile WHERE Id =: profileid LIMIT 1];
        for(Opportunity opportunity : opportunities) {
            if((opportunity.StageName == 'Closed Won' || opportunity.StageName == 'Closed Lost') && profileName.Name != 'System Administrator') {
                 opportunity.addError('No Access for Deletion');
            }
        }
    }

    //scenerio - 26
    public static void updateStageToClosedLostOrWon(List<Opportunity> opportunities, Map<Id,Opportunity> opportunityMap) {
        for(Opportunity opportunity : opportunities) {
            if(opportunity.StageName == 'Closed Lost'){
                opportunity.Description = 'Opportunity is Closed Lost';
            }
            else if(opportunity.StageName == 'Closed Won'){
                opportunity.Description = 'Opportunity is Closed Won';
            }
        }
    }
    
    //scenerio - 23
    public static void updateAccountAnnualRevenue(List<Opportunity> Opportunities){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity :Opportunities){
            if(opportunity.AccountId != NULL){
                accountIds.add(opportunity.AccountId);
            }
        }
        OpportunityService.updateAccountAnnualRevenue(accountIds);
        
    }

}