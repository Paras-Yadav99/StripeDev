public class StripePaymentCurrencyCode {
    @AuraEnabled
    public static AuraResponse getCurrencyCode(){
        AuraResponse AuraResponse;
        
        
        try {
            list<CurrencyCodeWrapper> lstWrapper = new list<CurrencyCodeWrapper>();
            string currencyCode =  Label.Stripe_Currency_Code;
            List<String> lstCurrencyCode = currencyCode.split(',');
            if(lstCurrencyCode!=null && !lstCurrencyCode.isEmpty()){
                for(string eachCurrencyCode : lstCurrencyCode){
                    lstWrapper.add(new CurrencyCodeWrapper(eachCurrencyCode,eachCurrencyCode));
                }
               
                AuraResponse = new AuraResponse(true, 'SUCCESS', JSON.serialize(lstWrapper));
            }else {
                AuraResponse = new AuraResponse(false, 'ERROR', 'No Currency Code Availabe');
            }
           
        } catch (Exception ex) {
            AuraResponse = new AuraResponse(false, 'ERROR', ex.getMessage());
        }
        
        return AuraResponse;
    }
    public class AuraResponse {

        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled  public string message;
        @AuraEnabled  public string response;

        public AuraResponse(Boolean isSuccess,
                                string message,
                                string response) {
            this.isSuccess = isSuccess;
            this.message = message;
            this.response = response;
        }
    }
     public class CurrencyCodeWrapper{
       	 @AuraEnabled public string label;
       	 @AuraEnabled public string value;
         
         public CurrencyCodeWrapper(string Label,
                        string Value
                       ) {
            this.label =  Label;
            this.value = Value;
         }
     }
                        
         
}