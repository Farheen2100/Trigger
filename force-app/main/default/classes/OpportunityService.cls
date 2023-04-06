public with sharing class OpportunityService {
    // scenerio - 5 24-March-2023 
    public static void PopulateOpportunityAmountOnAccount(List<Opportunity> opportunities) {
        List<Account> accounts  = new List<Account>();
        for(Opportunity opportunity: opportunities) {
            Account account = new Account();
            account.Id = opportunity.AccountId;
            account.Recent_Opportunity_Amount__c = opportunity.Amount;
            accounts.add(account);
        }
        if(!accounts.isEmpty()) {
            update accounts; 
        }
    }

    //scenerio - 7
    public static void createTaskOnOpportunity(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        List<Task> taskToInsert = new list<Task>();
        for(Opportunity opp : opportunities) {
            if(opportunityMap.get(opp.Id).StageName == 'Prospecting') {
                Task tasks = new Task();
                tasks.whatId = opp.Id;
                tasks.subject = 'Prospecting';
                taskToInsert.add(tasks);
            }
            else if(opp.StageName == 'Qualification') {
                Task tasks = new Task();
                tasks.whatId = opp.Id;
                tasks.subject = 'Qualification';
                
                taskToInsert.add(tasks);
            }
            else  if(opp.StageName == 'Needs Analysis') {
                Task tasks = new Task();
                tasks.whatId = opp.Id;
                tasks.subject = 'Needs Analysis';
                
                taskToInsert.add(tasks);
            }
            else if(opp.StageName == 'Closed Won') {
                Task tasks = new Task();
                tasks.whatId = opp.Id;
                tasks.subject = 'Closed Won';
                
                taskToInsert.add(tasks);
            }
            else if(opp.StageName == 'Closed Lost') {
                Task tasks = new Task();
                tasks.whatId = opp.Id;
                tasks.subject = 'Closed Lost';
                
                taskToInsert.add(tasks);
            }

        }
        if(!taskToInsert.isEmpty())
            insert taskToInsert ;
    }
    

    public static void updateAccountAnnualRevenue(Set<Id> accountIds) {
        List<Account> accounts = [SELECT id,AnnualRevenue,(SELECT accountId,Amount FROM Opportunities) 
        FROM account WHERE id =: accountIds];

        for(Account account :accounts){
            Decimal total = 0;
            for(Opportunity opportunity: account.opportunities){
                total+= opportunity.Amount;
            }
            account.AnnualRevenue = total;
        }
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}