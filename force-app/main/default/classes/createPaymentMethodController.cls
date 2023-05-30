public with sharing class createPaymentMethodController {
    public static Id recordId;
    public createPaymentMethodController() {
        
    }
    @AuraEnabled
    public static AuraResponse createPaymentMethod(string wrapperString,
                                                   Id accRecordId){
                                                       AuraResponse AuraResponse;
                                                       wrapper wrapper;
                                                       list<Account> lstAccount = new list<Account>();
                                                       try {
                                                           if(string.isNotBlank(wrapperString)){
                                                               wrapper = (wrapper)JSON.deserialize(wrapperString, wrapper.class); 
                                                               
                                                           } 
                                                           
                                                           if(String.isNotBlank(accRecordId)) {
                                                               recordId = accRecordId;
                                                               lstAccount = [SELECT Id,
                                                                             Stripe_Customer_Id__c FROM 
                                                                             Account WHERE Id =: accRecordId];
                                                                                
                                                           }
                                                           if(wrapper!=null && !lstAccount.isEmpty()) {
                                                               if(string.isNotBlank(lstAccount[0].Stripe_Customer_Id__c)){
                                                                   	hitPaymentMeethodAPI(wrapper,lstAccount[0].Stripe_Customer_Id__c);
                                                               		AuraResponse = new AuraResponse(true, 'SUCCESS', 'Payment Method Inserted Successfully!');

                                                               }else{
                                                                   AuraResponse = new AuraResponse(false, 'Error', 'No customer id found on Account!');
                                                               }
                                                           } else {
                                                               AuraResponse = new AuraResponse(false, 'Error', 'No Data Found!');
                                                           }
                                                           
                                                       } catch (Exception ex) {
                                                           AuraResponse = new AuraResponse(false, 'ERROR', ex.getMessage());
                                                       }
                                                       return AuraResponse;
                                                   }
    
    @TestVisible private static AuraResponse hitPaymentMeethodAPI(wrapper wrapper,
                                                     String stripeCustomerId) {
                                                         AuraResponse  AuraResponse;
                                                         string paymentMethodId;
                                                         if(String.isNotBlank(stripeCustomerId) && wrapper!=null) {
                                                             
                                                             string key = StripeIntegrationHelper.getSecretKey();
                                                             
                                                             StripePayment StripePayment = new StripePayment(key);
                                                             APIresponse paymentMethodResponse= StripePayment.createPaymentMethodInStripe('card', 
                                                                                                                                          wrapper.cardNumber,
                                                                                                                                          Integer.valueOf(wrapper.cardExpiryMonth),
                                                                                                                                          Integer.valueOf(wrapper.cardExpiryYear),
                                                                                                                                          null,
                                                                                                                                          null,
                                                                                                                                          false);
                                                             if(paymentMethodResponse.isSuccess) { 
                                                                 
                                                                 paymentMethodId =  paymentMethodResponse.response;
                                                                 
                                                                 APIresponse paymentMethodResponseForAttach= StripePayment.createPaymentMethodInStripe('card',
                                                                                                                                                       wrapper.cardNumber,
                                                                                                                                                       Integer.valueOf(wrapper.cardExpiryMonth),
                                                                                                                                                       Integer.valueOf(wrapper.cardExpiryYear),
                                                                                                                                                       stripeCustomerId,
                                                                                                                                                       paymentMethodId,
                                                                                                                                                       true);
                                                                 if(paymentMethodResponseForAttach.isSuccess) {

                                                                        
                                                                    
                                                                     Payment_Method__c objPaymentMethod = new Payment_Method__c();
                                                                     
                                                                     objPaymentMethod.Card_Number__c=wrapper.cardNumber;
                                                                     objPaymentMethod.PaymentMethod_Name__c = wrapper.PaymentMethodName;
                                                                     objPaymentMethod.Name = wrapper.PaymentMethodName;
                                                                     objPaymentMethod.Card_Expiry_Month__c= Integer.valueOf(wrapper.cardExpiryMonth);
                                                                     objPaymentMethod.card_Expiry_Year__c=Integer.valueOf(wrapper.cardExpiryYear);
                                                                     objPaymentMethod.CVV__c=wrapper.Cvv;
                                                                     objPaymentMethod.is_Default__c  = wrapper.isDefault;
                                                                     objPaymentMethod.Payment_Method_Id__c=paymentMethodId;
                                                                     objPaymentMethod.Account__c = recordId;
                                                                     Insert objPaymentMethod;
                                                                    
                                                                     AuraResponse = new AuraResponse(true, 'SUCCESS', null); 
                                                                 } else {
                                                                    APIErrorResponse StripeError = (APIErrorResponse)JSON.deserialize(paymentMethodResponseForAttach.message, APIErrorResponse.class);
                        
                                                                    
                                                                     throw new applicationException(StripeError.error.message);   
                                                                 }
                                                             } else {
                                                                APIErrorResponse StripeError = (APIErrorResponse)JSON.deserialize(paymentMethodResponse.message, APIErrorResponse.class);
                                                                 throw new applicationException(StripeError.error.message);   
                                                             }
                                                             
                                                         }
                                                         return AuraResponse;
                                                         
                                                     }
    
    public class applicationException extends Exception {}
    
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

    public class APIErrorResponse{
        public StripeError error;
        
    }

    
    public class StripeError {
            public String code;	//incorrect_number
            public String doc_url;	//https://stripe.com/docs/error-codes/incorrect-number
            public String message;	//Your card number is incorrect.
            public String param;	//number
            public String type;	//card_error
        
    }
    
    
    public class wrapper{
        public string Id;
        public string cardNumber;
        public string Name;
        public string Email;
        public string PaymentMethodName;
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
        public Boolean isDefault;
        
        public wrapper(string id,
                       string cardNumber,
                       string Name,
                       string Email,
                       Integer cardExpiryMonth,
                       Integer cardExpiryYear,
                       decimal Amount,
                       string CurrencyCode,
                       string PaymentMethodName,
                       string description,
                       string StripeId,
                       string CardType,
                       Integer Cvv,
                       Boolean isDefault) {
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
                           this.isDefault=isDefault;
                           this.PaymentMethodName= PaymentMethodName;
                       }
    }
}