public class BatchClass implements Database.Batchable<sObject> {
    
	public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c, Appointment_Day__c 
            FROM Appointment__c 
            WHERE Status__c = 'Scheduled' AND Appointment_Day__c < :System.now()
        ]);
    }
    
     public void execute(Database.BatchableContext bc, List<Appointment__c> appointments) {
        	for (Appointment__c app : appointments){
                AppointmentHandler obj = new AppointmentHandler();
                app = obj.setStatus(app);
                update app;
    		}
    }
    
    public void finish(Database.BatchableContext bc) {
         System.debug('Batch Completed');
    }
}