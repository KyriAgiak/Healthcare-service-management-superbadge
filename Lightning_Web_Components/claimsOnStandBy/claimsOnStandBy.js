import { LightningElement, wire, track} from 'lwc';
import getClaimDetails from '@salesforce/apex/InsuranceClaimController.getClaimDetails';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

export default class ClaimsOnStandBy extends NavigationMixin(LightningElement) {

    @track claims;
    @track error;
    @track count;
    @track hasPendingClaims = false;

    wiredClaimsResult;

    @wire(getClaimDetails)
    wiredClaimDetails(result) {
        this.wiredClaimsResult = result; // Store it for refreshApex
        const { data, error } = result;

        if (data) {
            this.claims = data;
            this.count = data.length;
            this.hasPendingClaims = true;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.claims = [];
        }
    }


        handleChoose(event){
        const id = event.target.dataset.id;
        
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: id,
                    objectApiName: 'Insurance_Claim__c', // Replace with your object API name
                    actionName: 'view'
                }
            })
        }

        handleViewPatient(event){
            const id = event.target.dataset.id;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: id,
                    objectApiName: 'Patient__c',
                    actionName: 'view'
                }
                
            })
        }

        get header() {
        console.log('method got called')
        return this.hasPendingClaims
            ? `You have ${this.count} claims awaiting approval`
            : 'You have no claims awaiting approval at this time';
        }


        get errorMessage() {
            if (this.error) {
                return this.error.body ? this.error.body.message : this.error.message;
            }
            return '';
        }

        connectedCallback() {
            if (this.wiredClaimsResult) {
                refreshApex(this.wiredClaimsResult);
            }
        }

}