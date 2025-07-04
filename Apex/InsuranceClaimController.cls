public with sharing class InsuranceClaimController {
    
    @AuraEnabled(cacheable=true)
    public static List<Insurance_Claim__c> getClaimDetails() {
        return [SELECT Id, Name, Claim_Status__c, Patient__r.Name, Patient__r.Id FROM Insurance_Claim__c WHERE Claim_Status__c = 'Pending'];
      
    }
}