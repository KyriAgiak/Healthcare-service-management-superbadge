public with sharing class AppointmentController {
    
   @AuraEnabled(cacheable=true)
    public static String getStatus(Id recordId) {
        try {
            if(recordId == null){
                throw new AuraHandledException('Invalid ID');
            }else{
            Appointment__c app = [SELECT Id, Status__c FROM Appointment__c WHERE Id = :recordId LIMIT 1];
            return app.Status__c;
            }
        } catch (Exception e) {
        throw new AuraHandledException('Could not retrieve appointment status: ' + e.getMessage());
        }   
    }


    @AuraEnabled(cacheable=true)
     public static String getPatient(Id recordId){
        try {
                if(recordId == null){
                    throw new AuraHandledException('Invalid ID');
                }else{
                Appointment__c app = [SELECT Id, Patient__c FROM Appointment__c WHERE Id = :recordId LIMIT 1];
                return app.Patient__c;
                }
            
            } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            }
     }

     @AuraEnabled
     public static void updateClaim(Id recordId, Id claimID){
        try {
            Appointment__c appointment = [SELECT Id, Insurance_Claim__c FROM Appointment__c WHERE Id = :recordId LIMIT 1];
            if (appointment.Insurance_Claim__c!=null){
                Insurance_Claim__c claim = [SELECT Id, Claim_Status__c FROM Insurance_Claim__c WHERE Id = :appointment.Insurance_Claim__c];
                claim.Claim_Status__c = 'Denied';
                update claim;
            }
            appointment.Insurance_Claim__c = claimID;
        
            update appointment;

            if (claimID!=null){
                Insurance_Claim__c newClaim = [SELECT Id, Claim_Status__c FROM Insurance_Claim__c WHERE Id = :claimID];
            
                //Calculating insurance claim value for inserted approved claim
                if (newClaim.Claim_Status__c == 'Approved'){
                    CalculateCost cost = new CalculateCost();
                    cost.setAmount(claimID);
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
     }
}