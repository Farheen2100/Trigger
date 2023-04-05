public class ContactService {
    public static void domainInsertByContactInsert(Set<Id> accountIds, Map<Id, String> accountIdToContactEmailMap, 
    List<Contact> contacts) 
    {
        List<Domain__c> domainNames = new List<Domain__c>();
        List<Domain__c> domains = new List<Domain__c>([SELECT Domain_Id__c, Name FROM Domain__c WHERE Domain_Id__c IN: accountIds]);
        List<Account> accounts = new List<Account>([SELECT Id FROM Account WHERE Id IN: accountIds]);
        Set<String> domainName = new Set<String>();
        for(Domain__c domain : domains){
            domainName.add(domain.Name);
        }
        for(Account account : accounts) {
                Domain__c domain = new Domain__c();
                domain.Domain_Id__c=account.Id;
                domain.Name=accountIdToContactEmailMap.get(account.Id);
                if(!domainName.contains(domain.Name)) {
                    domainNames.add(domain);
                }
        }
        insert domainNames;
    }
    
    public static void domainDeleteByContactDelete(List<Contact> contacts, Set<Id> accountIds) {    
        Map<Id, List<Domain__c>> accountIdToDomainsMap = new Map <Id, List<Domain__c>>();
        Map<Id, Set<String>> accountIdToEmailsMap = new Map<Id, Set<String>>();
        List<Domain__c> domainDelete = new List<Domain__c>();
        List<Domain__c> domains = new List<Domain__c>([SELECT Domain_Id__c, Name FROM Domain__c WHERE Domain_Id__c IN: accountIds]);
        for(Contact contact : contacts) {
            if(!accountIdToEmailsMap.containsKey(contact.AccountId)) {
                accountIdToEmailsMap.put(contact.AccountId, new Set<String>()); 
            }
            accountIdToEmailsMap.get(contact.AccountId).add(contact.Email.split('@').get(1));
        }
        for(Domain__c domain : domains) {
            if(!accountIdToDomainsMap.containsKey(domain.Domain_Id__c)) {
                accountIdToDomainsMap.put(domain.Domain_Id__c, new List<Domain__c>()); 
            }
            accountIdToDomainsMap.get(domain.Domain_Id__c).add(domain);
        }
        for(Id id : accountIdToDomainsMap.keySet()) {
            for(Domain__c domain : accountIdToDomainsMap.get(id)) {
                if(accountIdToEmailsMap.isEmpty() == true) {
                    domainDelete.add(domain);
                }
                else if(!accountIdToEmailsMap.get(id).contains(domain.Name)) {
                    domainDelete.add(domain);
                }
            }
        }
        delete domainDelete;
    }
}