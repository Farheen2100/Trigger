public with sharing class ContactTriggerHandler {
    
    public static void beforeInsert(List<Contact> contacts) {
         preventDuplicateEmails(contacts);
    }

    public static void afterInsert(List<Contact> contacts) {
        sentEmailOnContact(contacts);
    }

    //scenerio - 30
    public static void preventDuplicateEmails(List<Contact> contacts) {
        Set<String> emails = new Set<String>();
        for(Contact contact : contacts) {
            emails.add(contact.Email);
        }
        List<Contact> contactList = [SELECT Id, Name, Email FROM Contact WHERE Email =: emails];
        for(Contact contact : contacts) {
            if(contactList.size() > 0) {
                contact.Email.addError('You can not create a record because of same email');
            }
        } 
       
    }

    //scenerio - 21
    public static void sentEmailOnContact(List<Contact> contacts) {
            List<Messaging.Email> emails = new List<Messaging.Email>();
            for(Contact con : contacts) {
                if(con.Email != NULL) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[]{con.Email};
                email.setToAddresses(toAddress);
                String subject = 'Your Contact is created.' +con.FirstName;
                email.setSubject(subject);
                String disName = 'Farheen Bano';
                email.setSenderDisplayName(disName);
                String content = 'Hi';
                email.setHtmlBody(content);
                emails.add(email);
                 System.debug(emails);
                }
            }
            Messaging.sendEmail(emails);
            
    }
    
}