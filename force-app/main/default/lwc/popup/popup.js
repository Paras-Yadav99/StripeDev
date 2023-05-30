import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Popup extends LightningElement {
    @api emplyeeNumber; 
    @api message = 'Please enter the token!'; 
    @api confirmLabel = 'Submit'; 
    @api cancelLabel = 'Cancel'; 
    @track key;
    @track type= "password";


    
    handleConfirmClick(event){
        if(this.key && this.emplyeeNumber && this.key == this.emplyeeNumber) {
            this.handleCancelClick(true);
        } else {
            this.showNotification('Invalid key!', 'error', 'ERROR');
        }
        
    }

    handleCancel(event){
        this.handleCancelClick(false);
    }

    handleCancelClick(res){
        
        this.dispatchEvent(new CustomEvent('handlecancel', {detail: res}));
    }

    handleChange(event) {
        this.key = event.target.value;
    }

    showNotification(message, variant, title) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}