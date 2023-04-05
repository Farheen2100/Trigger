trigger ContactTrigger2 on Contact (before insert,after update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {  
	List<Contact> contacts = new List<Contact>();

for(Contact contact : trigger.new)
{
  Contact con = new Contact();
    if(con.BirthDate == NULL) {
        con.LastName = 'Test';
    
    con.BirthDate = Date.Today();
    contacts.add(con);
    }
} 
  
    
//update contacts;
        System.debug(contacts);
    }
}