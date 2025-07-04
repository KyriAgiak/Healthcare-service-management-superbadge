@isTest
private class ClaimTriggerTest {

    static void createData(){
        RecordType rt1 = [
            SELECT Id FROM RecordType WHERE SObjectType = 'Physician__c' AND Name = 'General Practitioner' LIMIT 1];

        RecordType rt2 = [SELECT Id FROM RecordType WHERE SObjectType = 'Appointment__c' AND Name = 'Routine Checkup' LIMIT 1];

        Physician__c doc = new Physician__c(
            Name = 'Dr. Doc Doe',
            Fee__c = 100,
            Specialty__c = 'Pathology',
            E_mail__c = 'DDOE@gmail.com',  
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
        System.debug('Data Created');
    }
    @isTest
    static void testWithDiscount() {
        createData();
        Physician__c doc = [SELECT Id, Fee__c FROM Physician__c WHERE Name = 'Dr. Doc Doe' LIMIT 1];
        Patient__c patient = [SELECT Id FROM Patient__c WHERE Name = 'Test Testopoulos' LIMIT 1];
        Appointment__c appointment = [SELECT Id, Physician__r.Fee__c FROM Appointment__c WHERE Patient__c = :patient.Id LIMIT 1];
        Insurance_Claim__c claim = new Insurance_Claim__c(
            Claim_Status__c = 'Pending',
            Coverage__c = 'Discount',
            Discount__c = 30,
            Patient__c = patient.Id
        );

        insert claim;

        // now update the appointment to link it to the claim
        appointment.Insurance_Claim__c = claim.Id;
        update appointment;

        decimal testAmount = doc.Fee__c - (claim.Discount__c/100) * doc.Fee__c;
        claim.Claim_Status__c = 'Approved'; // now update the claim to "Approved"
        update claim;
        decimal amount = [SELECT Id, Claim_Amount__c FROM Insurance_Claim__c WHERE Id = :claim.Id LIMIT 1].Claim_Amount__c;
        
        System.AssertEquals(testAmount, amount, 'oops');
        System.Debug('Test Completed');
    }

    @IsTest
    static void testWithFullCoverage() {
        createData();
        Physician__c doc = [SELECT Id, Fee__c FROM Physician__c WHERE Name = 'Dr. Doc Doe' LIMIT 1];
        Patient__c patient = [SELECT Id FROM Patient__c WHERE Name = 'Test Testopoulos' LIMIT 1];
        Appointment__c appointment = [SELECT Id, Physician__r.Fee__c FROM Appointment__c WHERE Patient__c = :patient.Id LIMIT 1];
        Insurance_Claim__c claim = new Insurance_Claim__c(
            Claim_Status__c = 'Pending',
            Coverage__c = 'Full Coverage',
            Patient__c = patient.Id
        );

        insert claim;

        // now update the appointment to link it to the claim
        appointment.Insurance_Claim__c = claim.Id;
        update appointment;

        claim.Claim_Status__c = 'Approved'; // now update the claim to "Approved"
        update claim;
        decimal amount = [SELECT Id, Claim_Amount__c FROM Insurance_Claim__c WHERE Id = :claim.Id LIMIT 1].Claim_Amount__c;
        
        System.AssertEquals(doc.Fee__c, amount, 'oops');
        System.Debug('Test Completed');
    }

  @IsTest
    static void testWithNoCoverage() {
        createData();
        Physician__c doc = [SELECT Id, Fee__c FROM Physician__c WHERE Name = 'Dr. Doc Doe' LIMIT 1];
        Patient__c patient = [SELECT Id FROM Patient__c WHERE Name = 'Test Testopoulos' LIMIT 1];
        Appointment__c appointment = [SELECT Id, Physician__r.Fee__c FROM Appointment__c WHERE Patient__c = :patient.Id LIMIT 1];
        Insurance_Claim__c claim = new Insurance_Claim__c(
            Claim_Status__c = 'Pending',
            Coverage__c = 'No Coverage',
            Patient__c = patient.Id
        );

        insert claim;

        // now update the appointment to link it to the claim
        appointment.Insurance_Claim__c = claim.Id;
        update appointment;

        claim.Claim_Status__c = 'Approved'; // now update the claim to "Approved"
        update claim;
        decimal amount = [SELECT Id, Claim_Amount__c FROM Insurance_Claim__c WHERE Id = :claim.Id LIMIT 1].Claim_Amount__c;
        
        System.AssertEquals(0, amount, 'oops');
        System.Debug('Test Completed');
    }
    
}