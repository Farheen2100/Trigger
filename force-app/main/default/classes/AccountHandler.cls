public with sharing class AccountHandler {
    public static void beforeInsert(List<Account> accounts) { 
        populateRatingToHot(accounts);
        copyBillingToShippingAddress(accounts);
    }

    public static void beforeUpdate(List<Account> accounts, Map<Id, Account> accountMap) { 
        populateDescriptionWhenPhoneUpdate(accounts, accountMap);
        updateBillingToShippingAddress(accounts, accountMap);
        preventUpdateOfRecord(accounts, accountMap);
    }

    public static void beforeDelete(List<Account> accounts, Map<Id, Account> accountMap) {
        preventAccountDelete(accounts);
        DeleteAccountBySystemAdministrator(accounts);
        ifNoopportunityThanAccountDelete(accounts, accountMap);
        ifNoCaseThanAccountDelete(accounts, accountMap);
        
    }

    public static void afterInsert(List<Account> accounts) {
        AccountService.createContactOnAccount(accounts);
        AccountService.createContactOrOpportunityOnAccount(accounts);
        AccountService.createRelatedOpportunityOnAccount(accounts);
        AccountService.sharingAccountRecordToStandardUser(accounts);
        
    }

    public static void afterUpdate(List<Account> accounts, Map<Id, Account> accountMap) {
        updateContactPhoneOnAccountPhone(accounts, accountMap);
        updateContactPhoneOnAccountPhoneBySOQL(accounts, accountMap);
        updateContactAddress(accounts, accountMap);
        updateContactAddressUsingSOQL(accounts, accountMap);
        updateActiveFeildOnAccount(accounts, accountMap);
        updateOpportunityOwner(accounts, accountMap);
        
    }

    public static void populateRatingToHot(List<Account> accounts) {
        for(Account account: accounts) {
            if(account.Industry == 'Media' && account.Industry != NULL) {
                account.Rating = 'Hot';
            }
        }
    }

    public static void copyBillingToShippingAddress(List<Account> accounts) {
        for( Account account : accounts){
            if(account.CopyBillingToShipping__c == True) {
                account.ShippingState = account.BillingState;
                account.ShippingStreet = account.BillingStreet;
                account.ShippingCity = account.BillingCity;
                account.ShippingPostalCode = account.BillingPostalCode;
                account.ShippingCountry = account.BillingCountry;  
            }
        }
    }

    
    
   

    //scenerio -1
    public static void populateDescriptionWhenPhoneUpdate(List<Account> accounts, Map<Id,Account> accountMap) {
        if(Trigger.isExecuting) {
            for(Account account: accounts) {
                if(accountMap.get(account.Id).Phone != NULL && account.Phone != accountMap.get(account.Id).Phone) {
                    account.Description = 'Phone is Updated! Old Value :'+ accountMap.get(account.Id).Phone + '& New Value : ' +account.Phone;
                }
            }
        }
    }

    //scenerio -2
    public static void updateBillingToShippingAddress(List<Account> accounts, Map<Id,Account> accountMap) {
        for(Account account: accounts) {
            if(account.CopyBillingToShipping__c == True) {
                account.ShippingState = account.BillingState;
                account.ShippingStreet = account.BillingStreet;
                account.ShippingCity = account.BillingCity;
                account.ShippingPostalCode = account.BillingPostalCode;
                account.ShippingCountry = account.BillingCountry;  
            }
        }
    }

    //scenerio - 3
    public static void updateContactPhoneOnAccountPhone(List<Account> accounts, Map<Id,Account> accountMap) {
        Set <Id> accountIds = new Set <Id>();
        Map <Id,String> accountMapForPhone = new Map <Id,string> ();
        for(Account acc : accounts) {
            if(accountMap.get(acc.Id).phone != acc.phone) {
                accountIds.add(acc.id);
                System.debug('1');
            }
            if(acc.phone != null) {
                accountMapForPhone.put(acc.id,acc.phone);
                System.debug('2');
            }
        }
        AccountService.updateContactPhoneOnAccountPhone(accountIds, accountMapForPhone  );
    }

    //scenerio - 4
    public static void updateContactPhoneOnAccountPhoneBySOQL(List<Account> accounts, Map<Id, Account> accountMap) {
        Set <Id> accountIds = new Set <Id>();
        
        for(Account acc : accounts) {
            if(accountMap.get(acc.Id).phone != acc.phone) {
                accountIds.add(acc.id);
                System.debug('1');
            }
        }
        AccountService.updateContactPhoneOnAccountPhoneBySOQL(accountIds);
        
    }

    //scenerio - 5
    public static void updateContactAddress(List<Account> accounts, Map<Id,Account> accountMap) {
        Map <Id,Account> accountMapForAddress = new Map <Id, Account> ();
        for(Account account : accounts) {
            if((account.BillingCity != accountMap.get(account.Id).BillingCity) || (account.BillingCountry != accountMap.get(account.Id).BillingCountry) 
              || (account.BillingState != accountMap.get(account.Id).BillingState) || (account.BillingStreet != accountMap.get(account.Id).BillingStreet) || (
                account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode )) {
                    accountMapForAddress.put(account.Id, account);
            }
        }
        AccountService.updateContactAddress(accountMapForAddress);
        
    }

    // scenerio - 6
    public static void updateContactAddressUsingSOQL(List<Account> accounts, Map<Id,Account> accountMap) {
        Set <Id> accountIds = new Set <Id>();
        for(Account acc : accounts) {
            if(accountMap.get(acc.Id).BillingCity != acc.BillingCity || accountMap.get(acc.Id).BillingCountry != acc.BillingCountry
            || accountMap.get(acc.Id).BillingPostalCode != acc.BillingPostalCode ||  accountMap.get(acc.Id).BillingState != acc.BillingState
            || accountMap.get(acc.Id).BillingStreet != acc.BillingStreet) {
                accountIds.add(acc.id);
                System.debug('1');
            }
        }
        AccountService.updateContactAddressUsingSOQL(accountIds);
       
    }

    //scenerio -8
    public static void updateActiveFeildOnAccount(List<Account> accounts, Map<Id, Account> accountMap) { 
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts) {
            if(account.Active__c == 'No' && account.Active__c != accountMap.get(account.id).Active__c ) {
                accountIds.add(account.Id);
            }
        }
        AccountService.updateActiveFeildOnAccount(accountIds);
        
    }

    //scenerio - 9 
    public static void preventAccountDelete(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Active__c == 'Yes') {
                account.adderror('you can not delete account');
            }
        }
    }

    // scenerio 10,11
    public static void preventUpdateOfRecord(List<Account> accounts, Map<Id, Account> accountMap) {
        Date previousdate = System.today() - 7;
        for(Account account : accounts) {
            if(accountMap.get(account.Id).CreatedDate == previousdate) {
                account.addError('You can not edit the record');
            }
        }
    }

    // scenerio - 13
    public static void DeleteAccountBySystemAdministrator(List<Account> accounts) {
        Id profileid = Userinfo.getProfileId();
        Profile profileNames = [SELECT Name FROM Profile WHERE Id =: profileid];
        for(Account account : accounts){
            if(profileNames.Name != 'System Administrator'){
                account.addError('No Access for Deletion');
            }
        }
    }

    //update opportunity owner
    public static void updateOpportunityOwner(List<Account> accounts, Map<Id, Account> accountMap) {
        Set<Id> accountIds = new Set<Id>();
        
        for(Account account : accounts) {
            accountIds.add(account.Id);
        }
        AccountService.updateOpportunityOwner(accountIds);
        
    }

    //scenerio - 15
    public static void ifNoopportunityThanAccountDelete(List<Account> accounts, Map<Id, Account> accountMap ) {
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity WHERE AccountId =: accountMap.keySet()];
        Set<Id> accountIds=new Set<Id>();
        for(Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.Accountid);
        }
        for(Account account : accounts)
            if(accountIds.contains(account.id)) {
                account.adderror('Account has opportunity in it, you can not delete it.'); 
                System.debug('ASDFGHJKL'); 
            }
    }

    //scenerio - 16
    public static void ifNoCaseThanAccountDelete(List<Account> accounts, Map<Id, Account> accountMap) {
        List<Case> caseList = [SELECT AccountId FROM Case WHERE AccountId =: accountMap.keySet()];
        Set<Id> accountIds=new Set<Id>();
        for(Case c : caseList) {
            accountIds.add(c.AccountId);
        }
        for(Account account : accounts) {
            if(accountIds.contains(account.id)) {
                account.adderror('Account has Case in  it, you can not delete it.'); 
            }
        }
    }

    


    

    
    
}