import { LightningElement, api, track } from 'lwc';
import createPaymentMethod from '@salesforce/apex/createPaymentMethodController.createPaymentMethod';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
let currentDate = new Date();


export default class CreatePaymentmethod extends LightningElement {
    @api recordId; 
    @track record = {isDefault : false};
    @track error;
    @track showSpinner=false;
    currentYear = currentDate.getFullYear();
    handleChange(event) {
        if(event.target.name=='isDefault'){
            this.record[event.target.name] = event.target.checked;
        }
        else{
            this.record[event.target.name] = event.target.value;
            
        }
       
    }

    handleCharge() {
        this.error = null;
        let isValid = this.validityCheck();
        this.showSpinner=true;
        if(isValid) {
            createPaymentMethod({wrapperString : JSON.stringify(this.record),
                                accRecordId: this.recordId}) 
            .then(result=>{
                if(result.isSuccess){
                    this.error = 'SUCCESS';
                    this.showSpinner=false;
                    this.record = {isDefault : false};
                    this.showNotification(result.response, 'success', 'SUCCESS');
                } else {
                    this.error = result.response;
                    this.showSpinner=false;
                    this.showNotification(result.response, 'error', 'ERROR');

                }
            })
            .catch(error=>{
                this.error = error;
                this.showSpinner=false;
                this.showNotification(error, 'error', 'ERROR');

            })
        }else {
            this.showSpinner=false;
        }
         
    }



    showNotification(message, variant, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    validityCheck(){
        let validity;
            let elements = Array.from(this.template.querySelectorAll('[data-id =checkValidity]'));
                if(elements!= undefined &&
                    elements!=null) {
                    validity =  elements.reduce((validSoFar,inputcmp) => {
                        inputcmp.reportValidity();
                        return validSoFar && inputcmp.checkValidity();
                    },true );
                }
        return validity;
    }


    
}