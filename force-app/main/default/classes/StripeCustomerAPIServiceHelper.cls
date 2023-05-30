public without sharing class StripeCustomerAPIServiceHelper {
	public Object StripeGetResponseValue{get;set;}
	public Object StripeResponseModel{get;set;}
	public static Integer statusCode;
	public static string response;
	public static String CUSTOMER_URL= getCustomerURL();// = 'https://api.stripe.com/v1/customers';
	public static String API_KEY;

    public StripeCustomerAPIServiceHelper(String apikey){
        API_KEY=apikey;
        
        
    }
    public static string getCustomerURL(){
        string CustomerURLDeveloperName = System.Label.Stripe_Customer_URL_Developer_Name;
        if(string.isnotBlank(CustomerURLDeveloperName)){
            Stripe_Url__mdt stripeURLPayment = [SELECT DeveloperName, 
                                                URL__c FROM Stripe_Url__mdt WHERE DeveloperName =: CustomerURLDeveloperName ] ;
            if(string.isNotBlank(stripeURLPayment.URL__c) ){
            	return  stripeURLPayment.URL__c;
                
            }
        }
        return null;
        
    }
	
    public APIresponse createCustomerInStripe(string email,
												string description,
												string name){

	HttpRequest HttpRequest = new HttpRequest();
	
	createCustomerRequest(email,
							description,
							name,
							HttpRequest);

	Http http = new Http();
	HttpResponse response = http.send(HttpRequest);
	
	APIresponse APIresponse = validateResponse(response);
	
	return APIresponse;
		
	}

	private  APIresponse validateResponse(HttpResponse response) {
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
	
	private  void createCustomerRequest(string email,
												string description,
												string name,
												HttpRequest HttpRequest) {

		
		string params;
		map<string, Object> mapOfParams = new map<string, Object>();
		mapOfParams.put('name', 'Sanjeet testing');
		HttpRequest.setEndpoint(CUSTOMER_URL);
                                                    
		HttpRequest.setMethod('POST');
		HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
		HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		

		 
		 	params = 'email=' + email+ '&name=' + name;

			params += String.isNotBlank(description) ? '&description=' + description : '';
		 

		HttpRequest.setBody(params); 
	}
    

}