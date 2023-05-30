public class CreateUpdateStripeSubscription {
    
    public static List<subscription__c> lstSubscription = new List<Subscription__c>();
    public static List<subscription__c> lstSubscriptionUpdate = new List<Subscription__c>();
    public static String SUBSCRIPTION_URL ;
    public CreateUpdateStripeSubscription(){
      	SUBSCRIPTION_URL = getSubscriptionURL();
        
    }
    public static string getSubscriptionURL(){
        string SubscriptionURLDeveloperName = System.Label.Stripe_Suscription_URL_Developer_Name;
        
        if(string.isnotBlank(SubscriptionURLDeveloperName)){
            Stripe_Url__mdt stripeURLSuscription = [SELECT DeveloperName, 
                                                URL__c FROM Stripe_Url__mdt WHERE DeveloperName =: SubscriptionURLDeveloperName ] ;
            if(string.isNotBlank(stripeURLSuscription.URL__c) ){
             
                return  stripeURLSuscription.URL__c;
                
            }
        }
        return null;
        
    }
    private static APIresponse validateResponseCreateSubscription(HttpResponse response, Id subId) {
        map<string,Object> mapOfBody;
        APIresponse APIresponse= new APIresponse();
        Integer statusCode = response.getStatusCode();
        
        if(statusCode == 200) {
            APIresponse.isSuccess = true;
          
            if(Test.isRunningTest()){
                //do something
            }else{
                mapOfBody = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
            }
           
            if(mapOfBody!=null && !mapOfBody.isEmpty()) {
				APIresponse.response = string.valueOf(mapOfBody.get('id'));
                lstSubscription.add(new Subscription__c(Stripe_Sub_Scheduled_Id__c = APIresponse.response,
                                                        Stripe_Subscription_Id__c = string.valueOf(mapOfBody.get('subscription')), 
                                                        Id = subId));
               
			}
        } else {
            APIresponse.isSuccess = false;
            APIresponse.message = response.getBody();
            lstSubscription.add(new Subscription__c(response__c = response.getBody(), Id = subId));
        }
        
        return APIresponse;
        
    }
    
    private static APIresponse validateResponseUpdateSubscription(HttpResponse response, Id subId) {
        map<string,Object> mapOfBody;
        APIresponse APIresponse= new APIresponse();
        Integer statusCode = response.getStatusCode();
        
        if(statusCode == 200) {
            APIresponse.isSuccess = true;
          
        } else {
            APIresponse.isSuccess = false;
            APIresponse.message = response.getBody();
            lstSubscriptionUpdate.add(new Subscription__c(response__c = response.getBody(), Id = subId));
        }
        
        return APIresponse;
        
    }
    
    public static void scheduleSubscription(Id subId, 
                                          String API_KEY, 
                                          String priceId, 
                                          String customerId, 
                                          String paymentMethodId,
                                          decimal startDate, 
                                          decimal endDate){
       //String SUBSCRIPTION_URL = 'https://api.stripe.com/v1/subscription_schedules';
        Http http = new Http();
        HttpRequest HttpRequest = new HttpRequest();
        HttpRequest.setEndpoint(SUBSCRIPTION_URL +'?');
        HttpRequest.setMethod('POST');
        HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
        HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded'); //+'&subscription='+subscriptionId;
        //String params = 'customer='+customerId+'&start_date='+startDate+'&phases[0][iterations]=12&phases[0][items][0][price]=price_1K0IauSDdfL2No7pz9knrsyV&phases[0][items][0][quantity]=1& default_payment_method=';
        String params = 'phases[0][items][0][price]='+priceId+'&customer='+customerId +'&phases[0][default_payment_method]='+paymentMethodId +'&start_date='+startDate+'&phases[0][end_date]='+endDate;

                                            
        HttpRequest.setBody(params);
        HttpResponse response;
        response = http.send(HttpRequest); 
        
         validateResponseCreateSubscription(response, subId);
    }
    
    public static void updatescheduleSubscription(Id subId,
                                                  String API_KEY,
                                                  String subscriptionId,
                                                  String scheudSubscriptionId,
                                                  String priceId,
                                                  String paymentMethodId,
                                                  Decimal startDate,
                                                  Decimal endDate){
       //String SUBSCRIPTION_URL = 'https://api.stripe.com/v1/subscription_schedules';
        Http http = new Http();
        HttpRequest HttpRequest = new HttpRequest();
        HttpRequest.setEndpoint(SUBSCRIPTION_URL+'/'+scheudSubscriptionId+'?');
        HttpRequest.setMethod('POST');
        HttpRequest.setHeader('Authorization', 'Bearer '+API_KEY);
        HttpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 
        String params = '&&phases[0][start_date]='+startDate+'&phases[0][end_date]='+endDate+'&phases[0][items][0][price]='+priceId+'&phases[0][items][0][quantity]=1';
                                             
        HttpRequest.setBody(params);
        HttpResponse response = http.send(HttpRequest); 
        
        validateResponseUpdateSubscription(response,subId);
    }  
}