import { LightningElement, api, wire, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getStatus from '@salesforce/apex/AppointmentController.getStatus';

export default class MoveAppointment extends LightningElement {

    @api recordId;
    @track isModalOpen = false;
    @track status;
    

    @wire(getStatus, {recordId: '$recordId'})
        wiredStatus({error, data}) {
        console.log(this.recordId)
        if (data){
            this.status = data;
            console.log(this.status);
        }
       else if(error){
            console.error(error);
            this.dispatchEvent(
                new ShowToastEvent({
                title: 'Error loading status',
                message: error.body ? error.body.message : error.message,
                variant: 'error',
            }),
            );
    }
        }

    get IsScheduled(){
        if (this.status === 'Scheduled'){
            return true
        } else{
            return false;
        }
    }


    showModal() {
        this.isModalOpen = true;
    }

    hideModal() {
        this.isModalOpen = false;
    }


    handleSave(event)  {
        const modalForm = this.template.querySelector('.modal-form');
        if (modalForm) {
        modalForm.submit();
        }
        refreshApex(this.wiredQuoteResult);
        this.hideModal();
    }

    handleCancel(){
        const inputFields = this.template.querySelectorAll('lightning-input-edit-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        } 
        this.hideModal();
    }
   

    handleSuccess(event){
       const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Appointment Date Changed Successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
        this.hideModal();
        
    }

    get hasRecordId() {
    return this.recordId !== undefined;
    }


}