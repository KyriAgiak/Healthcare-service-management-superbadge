@isTest
private class WeatherAPIHandlerTest {
    @isTest
    static void testGetWeatherDetails() {
        RecordType rt1 = [
            SELECT Id FROM RecordType WHERE SObjectType = 'Physician__c' AND Name = 'General Practitioner' LIMIT 1];

        RecordType rt2 = [SELECT Id FROM RecordType WHERE SObjectType = 'Appointment__c' AND Name = 'Routine Checkup' LIMIT 1];
        // Insert a dummy Physician
        Physician__c doc = new Physician__c(
            Name = 'Dr. Doc Doe',
            Fee__c = 100,
            Specialty__c = 'Pathology',
            E_mail__c = 'DDOE@gmail.com',
            DocLocation__City__s = 'Athens',
            RecordTypeId = rt1.Id
        );
        insert doc;

        Patient__c patient = new Patient__c(
            Name = 'Test Testopoulos',
            Primary_Physician__c = doc.Id,
            E_mail__c = 'test@gmail.com',
            Date_of_Birth__c = Date.newInstance(1980, 1, 1)
        );
        insert patient;

         Appointment__c appointment = new Appointment__c(
            Name = 'Test Appointment',
            Patient__c = patient.Id,
            Appointment_Day__c = Datetime.newInstance(2025, 12, 31, 12, 0, 0),
            Physician__c = doc.Id,
            RecordTypeId = rt2.Id,
            Status__c = 'Scheduled'
        );
        insert appointment;

        // Register the mock class for callout
        Test.setMock(HttpCalloutMock.class, new WeatherAPIMock());

        Test.startTest();
        List<String> result = WeatherAPIHandler.getWeatherDetails(appointment.Id);
        Test.stopTest();

        System.assertEquals(6, result.size(), 'Expected 6 elements in the result');
        System.assertEquals('Athens', result[0]);
        System.assertEquals('clear sky', result[1]);
        System.assert(result[2].contains('https://openweathermap.org/img/wn/01d@2x.png'), 'Expected valid icon URL');
        System.assertEquals('289.5', result[3]);
        System.assertEquals('287.3', result[4]);
        System.assertEquals('70', result[5]);
    }
}