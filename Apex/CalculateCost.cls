public class CalculateCost {

    public static Boolean hasRun = false;
    
    public void setAmount(String id){
       if (hasRun) return;
       hasRun = true;
       Insurance_Claim__c claim =[
           SELECT Id, Claim_Status__c, Coverage__c, Discount__c, Claim_Amount__c
           FROM Insurance_Claim__c WHERE Id = :id LIMIT 1
       ];
        if (claim.Claim_Status__c == 'Approved') {
        
            List<Appointment__c> appointments = [
                SELECT Id, Physician__r.Fee__c 
                FROM Appointment__c 
                WHERE Insurance_Claim__c = :id 
                LIMIT 1
            ];

            if (!appointments.isEmpty()){
                if(appointments[0].Physician__r.Fee__c != null && appointments[0].Physician__r.Fee__c != 0) {
                    Appointment__c app = appointments[0];
                    if (claim.Coverage__c == 'Discount' && claim.Discount__c != null && claim.Discount__c > 0){
                        Decimal discount = claim.Discount__c / 100;
                        claim.Claim_Amount__c = app.Physician__r.Fee__c - (discount * app.Physician__r.Fee__c);
                        update claim;
                    }else if (claim.Coverage__c == 'Full Coverage'){
                        claim.Claim_Amount__c = app.Physician__r.Fee__c;
                        System.debug('Full coverage' + claim.Claim_Amount__c);
                        update claim;
                    } else {
                        claim.Claim_Amount__c = 0;
                        update claim;
                    }
                }
            }
        }
    }
}