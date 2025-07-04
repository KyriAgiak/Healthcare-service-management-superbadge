import { LightningElement, api, wire, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getPatient from '@salesforce/apex/AppointmentController.getPatient';
import updateClaim from '@salesforce/apex/AppointmentController.updateClaim';

export default class ApplyForClaim extends LightningElement {

    @api recordId;
    @track patientId;
    @track error;
    @track claimId;
    @track isModalOpen = false;
    @track fields = [
        'Claim_Status__c',
        'Coverage__c',
        'Discount__c',
        'Claim_Amount__c',
        'Patient__c'
    ];


        @wire(getPatient, { recordId: '$recordId' })
        wiredPatient({ error, data }) {
        if (data) {
            this.patientId = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.patient = null;
        }
     }



        get patientId(){
            return this.patient.Id;
        }



        showModal() {
            this.isModalOpen = true;
        }

        hideModal() {
            this.isModalOpen = false;
        }


        handleSuccess(event){
        const newRecordId = event.detail.id;
        this.claimId = newRecordId;
        console.log(this.claimId);
        const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Item Added Successfully',
                variant: 'success',
            });
            this.dispatchEvent(toastEvent);
            updateClaim({ recordId: this.recordId, claimID: this.claimId })
                        .then(() => {
                        console.log('Apex call success');
                    })
                    .catch(error => {
                        console.error('Apex call failed:', error.body?.message || error.message);
                    });
            this.hideModal();
            
        }

        handleReset(event) {
            const inputFields = this.template.querySelectorAll('lightning-input-edit-field');
            if (inputFields) {
                inputFields.forEach(field => {
                    field.reset();
                });
            } 
            this.hideModal();
        }

        
        addNewItem() {
            const modalForm = this.template.querySelector('.modal-form');
            if (modalForm) {
            modalForm.submit();
        }
            
            this.hideModal();
        }
}