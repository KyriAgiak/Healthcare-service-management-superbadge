trigger ApprovedClaim on Insurance_Claim__c (after update) {
        if (Trigger.old[0].Claim_Status__c == 'Pending' && Trigger.new[0].Claim_Status__c== 'Approved'){
            Insurance_Claim__c claim = Trigger.new[0];
            CalculateCost cal = new CalculateCost();
            cal.setAmount(claim.Id);    
         }	     
}