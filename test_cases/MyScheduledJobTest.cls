@isTest
private class MyScheduledJobTest {
    @isTest
    static void testExecuteDirectly() {
        RecordType rt = [
        SELECT Id FROM RecordType WHERE SObjectType = 'Appointment__c' AND Name = 'Routine Checkup' LIMIT 1];
        
        Patient__c patient = new Patient__c(Name = 'John Doe',
        E_mail__c = 'test@gmail.com'
        ); 
        insert patient;
        
        DateTime futureDateTime = DateTime.now().addDays(Math.mod(Crypto.getRandomInteger(), 30) + 1);
        //DateTime pastDateTime = DateTime.now().addDays(-1 * (Math.mod(Crypto.getRandomInteger(), 30) + 1));


    	Appointment__c app = new Appointment__c(
        RecordTypeId = rt.Id,
        Name = 'test_appointment',
        Patient__c = patient.Id,
        Appointment_Day__c = futureDateTime,
        Status__c = 'Scheduled'
        );
        insert app;

        
        // Act: create instance and manually call execute()
        ScheduledClass job = new ScheduledClass();
        
        job.execute(null); // SchedulableContext can be null in unit tests
        
		Appointment__c appointment = [SELECT Id, Status__c FROM Appointment__c WHERE Id = :app.Id];
        System.assertEquals('Completed', appointment.Status__c, 'error');
    }
}