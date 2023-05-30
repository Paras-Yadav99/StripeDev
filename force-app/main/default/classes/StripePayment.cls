public without sharing class StripePayment{
	
	public static String PAYMENT_URL= getPaymentURL();
	public static String API_KEY;

	public StripePayment(String apikey){
		API_KEY=apikey;
        
	}
	
    public APIresponse createPaymentMethodInStripe(string type,
														string cardnumber,
														Integer cardExpiryMonth,
														Integer cardExpiryYear,
														string customerID,
														string paymentMethodId,
														Boolean isAttachCall){
    
	
	HttpRequest HttpRequest = new HttpRequest();
	                                                        
	if(isAttachCall){
        
		attachPaymentMethodToCustomerRequest(customerID,
												paymentMethodId,
												HttpRequest);
	} else{
		createPaymentMethodRequest(type,
									cardnumber,
									cardExpiryMonth,
									cardExpiryYear,
									HttpRequest);
	}
	

	Http http = new Http();
	HttpResponse response = http.send(HttpRequest);
	
	APIresponse APIresponse = validateResponse(response);

	return APIresponse;
		
	}

	private APIresponse validateResponse(HttpResponse response) {
		map<string,Object> mapOfBody;
		APIresponse APIresponse= new APIresponse();
		Integer statusCode = response.getStatusCode();

		if(statusCode == 200) {
			APIresponse.isSuccess = true;
			
			mapOfBody = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
			if(mapOfBody!=null && !mapOfBody.isEmpty()) {
				APIresponse.response = string.valueOf(mapOfBody.get('id'));
			}
			
		} else {
			APIresponse.isSuccess = false;
			APIresponse.message = response.getBody();
			
		}

		return APIresponse;

	}
	
	private void createPaymentMethodRequest(string type,
												string cardnumber,
												Integer cardExpiryMonth,
												Integer cardExpiryYear,
												HttpRequest HttpRequest) {

		
		string params;
		HttpRequest.setEndpoint(PAYMENT_URL);
		HttpRequest.setMethod('POST');
		HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
		HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		
		
		params = 'type=card'+ '&card[number]='+cardnumber+'&card[exp_month]='+cardExpiryMonth+'&card[exp_year]='+cardExpiryYear;

		
		HttpRequest.setBody(params); 
	}

	private void attachPaymentMethodToCustomerRequest(string customerId,
												string paymentMethodId,
												HttpRequest HttpRequest) {

		
		string params;
		HttpRequest.setEndpoint(PAYMENT_URL + '/'+paymentMethodId+'/attach');
		HttpRequest.setMethod('POST');
		HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
		HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		
		
			params = 'customer='+customerId;

		HttpRequest.setBody(params); 
	}
    
    public static string getPaymentURL(){
        string PaymentURLDeveloperName = System.Label.Stripe_Payment_URL_Developer_Name;
        if(string.isnotBlank(PaymentURLDeveloperName)){
            Stripe_Url__mdt stripeURLPayment = [SELECT DeveloperName, 
                                            URL__c FROM Stripe_Url__mdt WHERE DeveloperName =: PaymentURLDeveloperName ] ;
            if(stripeURLPayment!=null){
                PAYMENT_URL = stripeURLPayment.URL__c;
                return PAYMENT_URL;
            }
        }
        return null;
        
    }
    public class PaymentMethodWrapper{
        public String id;	//pm_1IgzdsSJhC5U83eH8I4ObaZu
        public cls_card card;
        public Integer created;	//123456789
        public string customer;
        public String type;	//card
    
    }
    
    public class cls_card {
        public Integer exp_month;	//8
        public Integer exp_year;	//2022
        public Integer cvc;	//2022
        public String funding;	//credit
        public String numberr;	//4242
    }
    

}