public class AppointmentHandler {
    
    public Appointment__c setStatus(Appointment__c app){
        app.Status__c = 'Completed';
        return app;
         
    }

}