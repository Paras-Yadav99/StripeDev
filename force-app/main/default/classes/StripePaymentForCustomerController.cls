public without sharing class StripePaymentForCustomerController {
    
   @AuraEnabled
    public static AuraResponse chargeUsingStripe(string wrapperString){
        AuraResponse AuraResponse;
        wrapper wrapper;
        try {
            if(string.isNotBlank(wrapperString)){
                wrapper = (wrapper)JSON.deserialize(wrapperString, wrapper.class);
            }

            if(wrapper!=null) {
               StripeIntegrationHelper.payUsingStripe(wrapper);
                AuraResponse = new AuraResponse(true, 'SUCCESS', 'Payment Successful!');
            } else {
                AuraResponse = new AuraResponse(false, 'Error', 'No Data Found!');
            }
           
        } catch (Exception ex) {
            
            AuraResponse = new AuraResponse(false, 'ERROR', ex.getMessage());//+ '-' + ex.getLineNumber() + '-' + ex.getStackTraceString());
        }
        return AuraResponse;
    }

    
    @AuraEnabled
    public static AuraResponse saveData(string wrapperString){
        AuraResponse AuraResponse;
        //Add you save logic here
        // AuraResponse AuraResponse;
        // wrapper wrapper;
        // try {
        //     if(string.isNotBlank(wrapperString)){
        //         wrapper = (wrapper)JSON.deserialize(wrapperString, wrapper.class);
        //     }

        //     if(wrapper!=null) {
        //         update new Lead(Id= wrapper.Id,
        //                         Card_Number__c = wrapper.cardNumber,
        //                         Card_Expiry_Month__c = wrapper.cardExpiryMonth,
        //                         Card_Expiry_Year__c = wrapper.cardExpiryYear,
        //                         Service_Fee__c = wrapper.Amount,
        //                         CCType__c = wrapper.CardType,
        //                         CVV__c = wrapper.Cvv);

        //         AuraResponse = new AuraResponse(true, 'SUCCESS', 'Record Saved!');
        //     } else {
        //         AuraResponse = new AuraResponse(false, 'Error', 'No Data Found!');
        //     }
        // } catch (Exception ex) {
        //     AuraResponse = new AuraResponse(false, 'ERROR', ex.getMessage());
        // }
        return AuraResponse;
    }    

    public class wrapper{
        public string Id;
        public string cardNumber;
        public string Name;
        public string Email;
        public Integer cardExpiryMonth;
        public Integer cardExpiryYear;
        public Double Amount;
        public string CurrencyCode;
        public string description;
        public string StripeId;
        public string CardType;
        public Integer Cvv;
        public string employeeNumber;
        public string Kennitala;

        public wrapper(string id,
                        string cardNumber,
                        string Name,
                        string Email,
                        Integer cardExpiryMonth,
                        Integer cardExpiryYear,
                        decimal Amount,
                        string CurrencyCode,
                        string description,
                        string StripeId,
                        string CardType,
                        Integer Cvv) {
            this.Id =  Id;
            this.cardNumber = cardNumber;
            this.Name = Name;
            this.Email = Email;
            this.cardExpiryMonth = cardExpiryMonth;
            this.cardExpiryYear = cardExpiryYear;
            this.Amount = Amount;
            this.CurrencyCode = CurrencyCode;
            this.description = description;
            this.StripeId = StripeId;
            this.CardType = CardType;
            this.Cvv = Cvv;

        }
    }

    public class AuraResponse {

        @auraEnabled public Boolean isSuccess;
        @auraEnabled  public string message;
        @auraEnabled  public string response;

        public AuraResponse(Boolean isSuccess,
                                string message,
                                string response) {
            this.isSuccess = isSuccess;
            this.message = message;
            this.response = response;
        }
    }
}