public class sendPaymentController {
    
    @AuraEnabled
    public static AuraResponse createPayment(String wrapperString,
                                             String accountId,
                                             String customerID){
        
        wrapper wrapper;
        AuraResponse AuraResponse;
        try{
                if(string.isNotBlank(wrapperString)){
                    wrapper = (wrapper)JSON.deserialize(wrapperString, wrapper.class);  
                    
            	}
            
            if(wrapper!=null) {
                    string key = StripeIntegrationHelper.getSecretKey();
                    stripePaymentInitiationServiceHelper str = new stripePaymentInitiationServiceHelper(key);
                    string paymentMethodId = wrapper.paymentMethodId;
                    system.debug(paymentMethodId);
                if(string.isNotBlank(paymentMethodId)) {
                     APIresponse APIresponse=str.createPaymentInitiationInStripe(Integer.valueOf(wrapper.amount)*100,
                                                                                wrapper.CurrencyCode,
                                                                                customerID,
                                                                                wrapper.description,
                                                                                paymentMethodId);
                    
                    if(APIresponse.isSuccess){
                        createSendMethod(wrapper.amount,
                                         wrapper.CurrencyCode,
                                         wrapper.description,
                                         APIresponse.response,accountId,
                                        paymentMethodId);
                        
                        AuraResponse = new AuraResponse(true, 'SUCCESS', 'Payment Inserted Successfully!');
                    }
                    else{
                       AuraResponse = new AuraResponse(APIresponse.isSuccess, APIresponse.message, APIresponse.response); 
                    }
                } else {
                    AuraResponse = new AuraResponse(false, 'ERROR', 'No default Payment Method found!');
                }
                   
            } else {
                AuraResponse = new AuraResponse(false, 'ERROR', 'Data not found!');
            }
        } catch(Exception ex) {
            AuraResponse = new AuraResponse(false, 'ERROR', ex.getMessage());
        }
        
        
        return AuraResponse;
    }
    @AuraEnabled
    public static List<sObject> search(String objectName, List<String> fields, String searchTerm, String accID){
        String whereClause = '';
        if(objectName.toLowerCase() == 'payment_method__c'){
            whereClause = ' And Account__c = \''+ accID +'\' ';
        }
        String returningQuery = '';
        returningQuery = ' Id, '+String.join(fields,',');
        String query = 'SELECT'+ returningQuery +' FROM '+ objectName +' WHERE Name LIKE \'%'+searchTerm+'%\' ' + whereClause + ' LIMIT 20';
        System.debug(query);
        List<sObject> searchRecords = Database.Query(query);
        return searchRecords;
    }
    
    
    
    
    @AuraEnabled
    public static void createSendMethod(decimal amount,
                                        String currencyCode,
                                        String description,
                                        String paymentId,
                                        String accountId,
                                       String paymentMethodId){
        Payment__c objPayment = new Payment__c();
        
        Payment_method__c paymentMethodAssociatedToPayment = new Payment_method__c(Payment_Method_Id__c  = paymentMethodId);
        objPayment.Amount__c=amount;
        objPayment.Currency_Code__c=currencyCode;
        objPayment.Account__c = accountId;
        objPayment.Payment_Id__c=paymentId;
        objPayment.Payment_Method__r = paymentMethodAssociatedToPayment;
        Insert objPayment;
        
    }
    
    public class wrapper{
   
        public decimal Amount;
        public string CurrencyCode;
        public string description;
        public string paymentMethodId;
        public string customerID;
        
        public wrapper(decimal Amount,
                       string CurrencyCode,
                       string description,
                       string paymentMethodId,
                       string customerID
                      ) {
                      
                          this.Amount = Amount;
                          this.CurrencyCode = CurrencyCode;
                          this.description = description; 
                    
                          this.paymentMethodId=paymentMethodId;
                          this.customerID=customerID;
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