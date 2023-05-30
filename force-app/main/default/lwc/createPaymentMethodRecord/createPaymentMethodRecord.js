import { LightningElement,track,api,wire } from 'lwc';
import createPayment from '@salesforce/apex/sendPaymentController.createPayment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Stripe_Customer_FIELD from '@salesforce/schema/Account.Stripe_Customer_Id__c';
import Payment_Method_FIELD from '@salesforce/schema/Payment_Method__c.Payment_Method_Id__c';

import getCurrenctCode from '@salesforce/apex/StripePaymentCurrencyCode.getCurrencyCode';

const fields = [Stripe_Customer_FIELD];
export default class CreatePaymentMethodRecord extends LightningElement {
    
    @api recordId; 
    @track record = {};
    @track showSpinner=false;
    @track amount;
    @track CurrencyCode;
    @track currencyCodeValue = [];
    description;
    paymentMethodId;
    stripePaymentId;
    fields = ["Name","Payment_Method_Id__c"];
    displayFields = 'Name';
    connectedCallback(){
        this.init();
    }
    init(){
        getCurrenctCode()
        .then(result=>{
            if(result.isSuccess) {
                this.currencyCodeValue = JSON.parse(result.response);
                
            }else{
                this.error = result.response;
                this.showNotification(this.error, 'error', 'ERROR');
            }
        })
        .catch(error=>{
            this.error = error;
            this.showNotification(error, 'error', 'ERROR');
        })
    }
    
    @wire(getRecord, { recordId: '$recordId',fields})
    account;
    get StripeCustomerID() {
        return getFieldValue(this.account.data,Stripe_Customer_FIELD);
    }
    handleChange(event) {
       
        this.record[event.target.name] = event.target.value;       
    }
    handleLookup(event){
        debugger;
        if(event.detail.data != undefined || event.detail.data != null){
            this.record[event.target.name] = event.detail.data.record[Payment_Method_FIELD.fieldApiName];
        } else {
            this.record[event.target.name] = null;
        }
    }

    handleCharge() {
        
        this.error = null;
        let isValid = this.validityCheck();
        this.showSpinner=true;
        if(isValid) {
            createPayment({wrapperString:JSON.stringify(this.record),
                accountId: this.recordId,customerID: this.StripeCustomerID})                                 
            .then(result=>{
                if(result.isSuccess){                  
                    this.error = 'SUCCESS';  
                    this.showSpinner=false;                 
                    this.showNotification(result.response, 'success', 'SUCCESS');
                    this.stripePaymentId =result.Id;
                    this.resetVariables();
                    
                } else {
                    this.error = result.response;
                    this.showSpinner=false;
                    
                    this.showNotification(this.error, 'error', 'ERROR');
                    

                }
            })
            .catch(error=>{
                this.error = error;
                this.showSpinner=false;
                this.showNotification(error, 'error', 'ERROR');

            })
        }
         
    }

    

    resetVariables() {
        
        this.amount = null;
        this.CurrencyCode = null;
        this.description = null;
        this.paymentMethodId = null;
        this.stripePaymentId = null;
        this.template.querySelector("c-custom-lookup-component").handleClose();
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