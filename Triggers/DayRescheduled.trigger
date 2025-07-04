trigger DayRescheduled on Appointment__c (before update) {

        Date today = Date.today();
        for (Appointment__c app : Trigger.new){
           app.Day_Rescheduled__c = today;
        }    
}