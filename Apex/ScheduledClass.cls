public class ScheduledClass implements schedulable{
    
    public void execute(SchedulableContext context) {
        Database.executeBatch(new BatchClass());
        System.debug('done');
	}
}

//String cron = '0 0 * * * ?'; // Every hour
//System.schedule('AutoCompleteAppointments', cron, new ScheduledClass());