public without sharing class StripeIntegrationHelper {
    
    public static string customerId;
    public static string paymentMethodId;
    
    public static void payUsingStripe(StripePaymentForCustomerController.wrapper leadObject) { 
		string key = getSecretKey(); 
        
        if(String.isNotBlank(key)) {
            APIresponse customerResponse = createCustomerInStripe(key, leadObject);
            
            if(customerResponse.isSuccess) {
                customerId =  customerResponse.response;
                APIresponse paymentMethodResponse = createPaymentMethodInStripe(key, 
                                                                                leadObject,
                                                                                false);
                
                if(paymentMethodResponse.isSuccess) {
                    paymentMethodId =  paymentMethodResponse.response;
                    APIresponse paymentMethodResponseForAttach = createPaymentMethodInStripe(key, 
                                                                                             leadObject,
                                                                                             true);
                    if(paymentMethodResponseForAttach.isSuccess) {
                        APIresponse paymentInitiationResponseForAttach = createPaymentInitiateInStripe(key, 
                                                                                                       leadObject);
                        if(paymentInitiationResponseForAttach.isSuccess){
                            
                        }else {
                            throw new applicationException(paymentInitiationResponseForAttach.message);
                        }
                        
                    } else {
                        throw new applicationException(paymentMethodResponseForAttach.message);    
                    }
                } else {
                    throw new applicationException(paymentMethodResponse.message);
                }
            } else {
                throw new applicationException(customerResponse.message);
            }
            
        }
    }
    
    
    
    public static string getSecretKey() {
        stripe_details__mdt stripedetails = [SELECT Id, 
                                             DeveloperName, 
                                             QualifiedApiName, 
                                             Stripe_secret_key__c FROM stripe_details__mdt 
                                             WHERE developerName = 'stripe_details'];
        
        if(stripedetails!=null) {
            return stripedetails.Stripe_secret_key__c;
        }
        
        return null;
    }
    
    private static APIresponse createCustomerInStripe(string key, StripePaymentForCustomerController.wrapper leadObject) {
        
        StripeCustomerAPIServiceHelper StripeCustomerAPIServiceHelper = new StripeCustomerAPIServiceHelper(key); 
        APIresponse APIresponse = StripeCustomerAPIServiceHelper.createCustomerInStripe(leadObject.email,
                                                                                        leadObject.description,
                                                                                        leadObject.name);
        
        return APIresponse;
    }
    
    private static APIresponse createPaymentMethodInStripe(string key,
                                                           StripePaymentForCustomerController.wrapper leadObject,
                                                           Boolean isAttachCall) {
                                                               
                                                               StripePayment StripePayment = new StripePayment(key);
                                                               APIresponse APIresponse= StripePayment.createPaymentMethodInStripe('card',
                                                                                                                                  leadObject.cardNumber,
                                                                                                                                  Integer.valueOf(leadObject.cardExpiryMonth),
                                                                                                                                  Integer.valueOf(leadObject.cardExpiryYear),
                                                                                                                                  customerID,
                                                                                                                                  paymentMethodId,
                                                                                                                                  isAttachCall);
                                                               
                                                               return APIresponse;
                                                           }
    
    private static APIresponse createPaymentInitiateInStripe(string key,
                                                             StripePaymentForCustomerController.wrapper leadObject) {
                                                                 
                                                                 stripePaymentInitiationServiceHelper stripePaymentInitiationServiceHelper = new stripePaymentInitiationServiceHelper(key);
                                                                 APIresponse APIresponse = stripePaymentInitiationServiceHelper.createPaymentInitiationInStripe(Integer.valueOf(leadObject.Amount*100),
                                                                                                                                                                (leadObject.CurrencyCode).toLowerCase(),
                                                                                                                                                                customerID,
                                                                                                                                                                leadObject.description, 
                                                                                                                                                                paymentMethodId);
                                                                 
                                                                 return APIresponse;
                                                             }
    
    
    public class applicationException extends Exception {}
    
    public static void createSubScriptionMethod(String key, Set<Id> setIds){
        
        Boolean isDefaultPMAvailable = false;
        Set<Id> setAccId = new Set<Id>();
        List<Payment_method__c> lstPMs = new List<Payment_method__c>();
        Map<Id, List<Subscription__c>> mapAccIdSubscription = new Map<Id, List<Subscription__c>>();
        Map<Id, Payment_method__c> mapAccIdPMs = new Map<Id, Payment_Method__c>();
        List<Subscription__c> lstSub = [SELECT Id,
                                        Account__c,
                                        Stripe_Sub_Scheduled_Id__c,
                                        timestamp_for_start_date__c,
                                        timeStampFor_End_date__c,
                                        Name, 
                                        Price__c,
                                        Price_Stripe_Id__c,
                                        End_Date__c,
                                        Start_Date__c,
                                        isActive__c FROM Subscription__c WHERE ID IN: setIds];
        if(!lstSub.isEmpty()) {
            for(Subscription__c subScriptn : lstSub){
                if(!mapAccIdSubscription.containsKey(subScriptn.Account__c)){
                    mapAccIdSubscription.put(subScriptn.Account__c, new List<Subscription__c>{subScriptn});
                } else{
                    mapAccIdSubscription.get(subScriptn.Account__c).add(subScriptn);
                }
            }
        }
        
        if(!mapAccIdSubscription.keyset().isEmpty()) {
            lstPMs = [SELECT Id, 
                      is_Default__c,
                      Account__c, 
                      Account__r.Stripe_Customer_Id__c , 
                      Payment_Method_Id__c
                      FROM Payment_Method__c WHERE Account__c IN : mapAccIdSubscription.keyset() AND is_Default__c = true];
        }
        if(lstPms!=null && !lstPms.isEmpty()) {
            for(Payment_method__c pms : lstPMs){
                mapAccIdPMs.put(pms.Account__c, pms);
            }
        }
        
        
        for(Id ids : mapAccIdSubscription.keySet()){
            for(Subscription__c sub : mapAccIdSubscription.get(ids)){

                    CreateUpdateStripeSubscription.scheduleSubscription(sub.Id,
                                                                        key,
                                                                        sub.Price_Stripe_Id__c,
                                                                        mapAccIdPMs.get(ids).Account__r.Stripe_Customer_Id__c,
                                                                        mapAccIdPMs.get(ids).Payment_Method_Id__c,
                                                                        sub.timestamp_for_start_date__c,
                                                                        sub.timeStampFor_End_date__c);
            }
            
        }
        
        if(!CreateUpdateStripeSubscription.lstSubscription.isEmpty()){
            update CreateUpdateStripeSubscription.lstSubscription;
        }
        
        
    }
    
    public static void updateSubscriptionMethod(String key, Set<Id> setIds){
        Boolean isDefaultPMAvailable = false;
        Set<Id> setAccId = new Set<Id>();
        List<Payment_method__c> lstPMs = new List<Payment_method__c>();
        Map<Id, List<Subscription__c>> mapAccIdSubscription = new Map<Id, List<Subscription__c>>();
        Map<Id, Payment_method__c> mapAccIdPMs = new Map<Id, Payment_Method__c>();
        List<Subscription__c> lstSub = [SELECT Id,
                                        Account__c, 
                                        Name, 
                                        Stripe_Subscription_Id__c, 
                                        Stripe_Sub_Scheduled_Id__c,	
                                        timestamp_for_start_date__c,
                                        timeStampFor_End_date__c,
                                        Price__c,
                                        Price_Stripe_Id__c,
                                        End_Date__c,
                                        Start_Date__c, 
                                        isActive__c FROM 
                                        Subscription__c WHERE ID IN: setIds];
        if(!lstSub.isEmpty()) {
            for(Subscription__c subScriptn : lstSub){
                if(!mapAccIdSubscription.containsKey(subScriptn.Account__c)){
                    mapAccIdSubscription.put(subScriptn.Account__c, new List<Subscription__c>{subScriptn});
                } else{
                    mapAccIdSubscription.get(subScriptn.Account__c).add(subScriptn);
                }
            }
        }
        
        if(!mapAccIdSubscription.keyset().isEmpty()) {
            lstPMs = [SELECT Id, 
                      is_Default__c,
                      Account__c, 
                      Account__r.Stripe_Customer_Id__c , 
                      Payment_Method_Id__c
                      FROM Payment_Method__c WHERE Account__c IN : mapAccIdSubscription.keyset() AND is_Default__c = true];
        }
        if(lstPms!=null && !lstPms.isEmpty()) {
            for(Payment_method__c pms : lstPMs){
                mapAccIdPMs.put(pms.Account__c, pms);
            }
        }
        
        for(Id ids : mapAccIdSubscription.keySet()){
            for(Subscription__c sub : mapAccIdSubscription.get(ids)){

                    CreateUpdateStripeSubscription.updatescheduleSubscription(sub.Id,
                                                                              key,
                                                                              sub.Stripe_Subscription_Id__c,
                                                                              sub.Stripe_Sub_Scheduled_Id__c,
                                                                              sub.Price_Stripe_Id__c,
                                                                              mapAccIdPMs.get(ids).Payment_Method_Id__c,
                                                                              sub.timestamp_for_start_date__c,
                                                                              sub.timeStampFor_End_date__c);
            }
            
        }
        
        if(!CreateUpdateStripeSubscription.lstSubscriptionUpdate.isEmpty()){
             update CreateUpdateStripeSubscription.lstSubscriptionUpdate;
        }
        
    }
    
    public static void deleteSubscriptionMethod(String key, Set<Id> setIds){
        
        List<Subscription__c> lstSub = [SELECT Id,Account__c, Name, Stripe_Subscription_Id__c,Stripe_Sub_Scheduled_Id__c, Price__c,Price_Stripe_Id__c,End_Date__c,Start_Date__c, isActive__c FROM Subscription__c WHERE ID IN: setIds];
        if(!lstSub.isEmpty()){
            for(Subscription__c sub : lstSub){
                    DeleteSubscriptionInStripe.getScription(sub.Id,key,sub.Stripe_Sub_Scheduled_Id__c);
            } 
        }
        
        if(!DeleteSubscriptionInStripe.lstSubscriptionDelete.isEmpty()){
            update DeleteSubscriptionInStripe.lstSubscriptionDelete;
        }
        
    }  
    
    
}