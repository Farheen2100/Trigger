public with sharing class AccountService {
    public static void createContactOnAccount(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for(Account account: accounts) {
            Contact contact = new Contact ();
            contact.FirstName = 'test';
            contact.AccountId = account.Id;
            contact.LastName = account.Name;
            contacts.add(contact);
        }
        if(!contacts.isEmpty()) {
            insert contacts;
        } 
    }

    public static void createContactOrOpportunityOnAccount(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account: accounts) {
            if(account.Contact__c == True) {
                Contact contact = new Contact ();
                contact.FirstName = 'contact test';
                contact.AccountId = account.Id;
                contact.LastName = account.Name;
                contacts.add(contact);
            }
            else {
                if(account.Active__c == 'Yes' && account.Opportunity__c == True) {
                    Opportunity opportunity = new Opportunity ();
                    opportunity.Name = account.Name+'test';
                    opportunity.AccountId = account.Id;
                    opportunity.CloseDate = Date.today();
                    opportunity.StageName = 'Closed Lost';
                    opportunities.add(opportunity);
                }

            } 
        }
        if(!contacts.isEmpty()) {
            insert contacts;
        }
        else {
            if(!opportunities.isEmpty()) {
                insert opportunities;
            }
        }
    }

    public static void createRelatedOpportunityOnAccount(List<Account> accounts) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account: accounts) {
            Opportunity opportunity = new Opportunity ();
            opportunity.Name = account.Name;
            opportunity.AccountId = account.Id;
            opportunity.CloseDate = Date.today();
            opportunity.StageName = 'Closed Lost';
            opportunities.add(opportunity);
        }
        if(!opportunities.isEmpty()) {
            insert opportunities;
        }
    }

    //scenerio - 31
    public static void SharingAccountRecordToStandardUser(List<Account> accounts) {
        List<AccountShare> accountSharesToCreate = new List<AccountShare>();
        Id standardUserProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        Group publicGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Admins'];
        for (Account account : accounts) {
        for (User standardUser : [SELECT Id FROM User WHERE ProfileId = :standardUserProfileId]) {
            AccountShare accountShare = new AccountShare();
            accountShare.AccountId = account.Id;
            accountShare.UserOrGroupId = publicGroup.Id;
            accountShare.RowCause = 'Manual';
            accountShare.AccountAccessLevel = 'Edit';
            accountShare.OpportunityAccessLevel = 'Edit';
            accountSharesToCreate.add(accountShare);
        }
        if (accountSharesToCreate.size() > 0) {
            insert accountSharesToCreate;
        }
    }
    }

    public static void updateContactPhoneOnAccountPhone(Set<Id> AccountIds, Map <Id,String> accountMapForPhone, List <contact> contacts) {
        for(Contact con:[SELECT Id,accountId,HomePhone FROM Contact where accountId =: accountIds]) {
            if(accountMapForPhone != null && accountMapForPhone.containsKey(con.accountId)) {
                System.debug('3');
                con.HomePhone = accountMapForPhone.get(con.accountId);
                contacts.add(con);
                System.debug('4');

            }
        }
        if(!contacts.isEmpty()) {
            update contacts;
            System.debug('contact'+contacts);
        }
    }

    public static void updateContactPhoneOnAccountPhoneBySOQL(Set<Id> accountIds) {
        List<Contact> contacts = new List<Contact>();
        List<Account> accountList = [SELECT Id,Phone,(SELECT HomePhone FROM Contacts) FROM Account WHERE Id =: accountIds];
            for(Account account: accountList) {
            if(account.Contacts != NULL) {
                for(Contact contact: account.Contacts) {
                    contact.HomePhone = account.Phone;
                    contacts.add(contact);
                }
            }
        }
        if(!contacts.isEmpty()) {
            update contacts;
        }
    }

    public static void updateContactAddress(Map <Id,Account> accountMapForAddress) {
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId =: accountMapForAddress.keySet()];
        for(Contact contact: contacts) {
            contact.MailingCity = accountMapForAddress.get(contact.AccountId).BillingCity;
            contact.MailingCountry = accountMapForAddress.get(contact.AccountId).BillingCountry;
            contact.MailingPostalCode = accountMapForAddress.get(contact.AccountId).BillingPostalCode;
            contact.MailingState = accountMapForAddress.get(contact.AccountId).BillingState;
            contact.MailingStreet = accountMapForAddress.get(contact.AccountId).BillingStreet;
        }
        update contacts;
        System.debug('contact'+contacts);
    }

    public static void updateContactAddressUsingSOQL(Set<Id> accountIds) {
        List<Contact> contacts = new List<Contact>();
        List<Account> accountList = [SELECT Id,BillingCity,BillingCountry,BillingPostalCode, BillingState, BillingStreet, (SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet  FROM Contacts) FROM Account WHERE Id =: accountIds];
        for(Account account: accountList) {
            if(account.Contacts != NULL) {
                for(Contact contact: account.Contacts) {
                    contact.MailingCity = account.BillingCity;
                    contact.MailingStreet = account.BillingStreet;
                    contact.MailingPostalCode = account.BillingPostalCode;
                    contact.MailingState = account.BillingState;
                    contact.MailingCountry = account.BillingCountry;
                    contacts.add(contact);
                }
            }
        }
        if(!contacts.isEmpty()) {
            update contacts;
        }
    }

    public static void updateActiveFeildOnAccount(Set<Id> accountIds) {
        List<Opportunity> opps = [SELECT Id, StageName FROM Opportunity WHERE AccountId in: accountIds and StageName != 'close won'];
        if (!opps.isEmpty()) {
            for (Opportunity opp : opps) {
                opp.StageName = 'Closed Lost';
            }
            update opps;
        }
    }

    public static void updateOpportunityOwner(Set<Id> accountIds) {
        List<Opportunity> opportunities = [SELECT  id,ownerid,Account.OwnerID FROM Opportunity WHERE AccountID =: accountIds];
        if(accountIds != NULL) {
            for(Opportunity opportunity : opportunities) {
                opportunity.OwnerId = opportunity.Account.OwnerId;
               
            }
        }
        if(!opportunities.isEmpty()) {
            update opportunities;
        }
    }

}