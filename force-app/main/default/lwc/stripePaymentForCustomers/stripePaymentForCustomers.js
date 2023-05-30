import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chargeUsingStripe from '@salesforce/apex/StripePaymentForCustomerController.chargeUsingStripe';
import saveData from '@salesforce/apex/StripePaymentForCustomerController.saveData';
import getCurrenctCode from '@salesforce/apex/StripePaymentCurrencyCode.getCurrencyCode';

let currentDate = new Date();
 

export default class StripePaymentForCustomers extends LightningElement {
    @track showSpinner=false;
    @api recordId;
    @track record = {};
    @track error;
    @track currencyCodeValue = [];
    currentYear = currentDate.getFullYear();
    //currentMonth = currentDate.getMonth();
    // @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: CARD_TYPE })
    // cardtype;

    get cardtypePicklist() {
        return (this.cardtype && this.cardtype.data && this.cardtype.data.values);
    }

    get disableChargeButton() {
        return this.record.StripeId;
    }

    connectedCallback(){
        this.init();
    }
    init(){
        getCurrenctCode()
        .then(result=>{
            if(result.isSuccess) {
                
                this.currencyCodeValue = JSON.parse(result.response);
                
                //this.value = this.currencyCodeValue.Value;
                //this.Label = this.currencyCodeValue.Label;
            }else{
                
                this.error = result.response;
                this.showNotification(result.response, 'error', 'ERROR');
            }
        })
        .catch(error=>{
           
            this.error = error;
            this.showNotification(error, 'error', 'ERROR');
        })
    }
   
    // init() {
    //     this.error = null;
    //     getData({recordId : this.recordId})
    //     .then(result=>{
    //         if(result.isSuccess) {
    //             this.record = JSON.parse(result.response);
    //         } else{
    //             this.error = result.response;
    //             this.showNotification(result.response, 'error', 'ERROR'); 

    //         }
    //     })
    //     .catch(error=>{
    //         this.error = error;
    //         this.showNotification(error, 'error', 'ERROR');

    //     })
    // }

    handleChange(event) {
        this.record[event.target.name] = event.target.value;

    }

    handleCharge() {
        this.error = null;
        let isValid = this.validityCheck();
        this.showSpinner=true;
        if(isValid) {
            chargeUsingStripe({wrapperString : JSON.stringify(this.record)})
            .then(result=>{
                if(result.isSuccess){
                    this.error = 'SUCCESS';
                    this.showSpinner=false;
                    this.showNotification(result.response, 'success', 'SUCCESS');
                    this.record = {};
                } else {
                    this.error = JSON.parse(result.response);
                    this.showSpinner=false;
                    this.showNotification(this.error.error.message, 'error', 'ERROR');

                }
            })
            .catch(error=>{
                this.error = error;
                this.showSpinner=false;
                this.showNotification(error, 'error', 'ERROR');

            })
        }else{
            this.showSpinner=false;
        }
         
    }

    // handleSave(event) {
    //     saveData({wrapperString : JSON.stringify(this.record)})
    //     .then(result =>{
    //         if(result.isSuccess){
    //             this.error = 'SUCCESS';
    //             this.showNotification(result.response, 'success', 'SUCCESS');
    //         } else {
    //             this.error = result.response;
    //             this.showNotification(result.response, 'error', 'ERROR');

    //         }
    //     })
    //     .catch(error =>{
    //         this.error = error;
    //         this.showNotification(error, 'error', 'ERROR');
    //     })

    // }

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

    // closePopUp(event) {
    //     this.showPopUp = false;
    //     let encryptionSuccess = event.detail;
    //     if(encryptionSuccess) {
    //         this.isEncryted = false;
    //     } else {
    //         this.isEncryted = true;
    //     }
    // }

    // handleDecrypt() {
    //     this.showPopUp = true;
    // }

    showNotification(message, variant, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
    
}