public without sharing class WebhookTriggerHandler implements ITriggerHandler{

    public static Boolean TriggerDisabled = false;
    public static final string INVOICE_TYPE_SUCCESS = 'invoice.payment_succeeded'; 
    public static final string INVOICE_TYPE_FAILED = 'invoice.payment_failed'; 
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public void beforeInsert(List<sObject> listofCompanyUser) {  
    }
    //When webhook create then invoice and payment record insert
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
        createPaymentAndInvoice((list<Webhook__c>)newList);
    }  
    
    public  void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
    }
    
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) {
    }
    
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap){
    }

    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
    }
    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
    }
    // this method is used for create invoice and payment when webhook invoice record is created
    public void createPaymentAndInvoice(list<Webhook__c> triggerNew){
        List<wrapperForInvoice> listOfWrapperForInvoice = new List<wrapperForInvoice>();
        Set<String> listAccountStripeId = new Set<String>();
        Set<String> listSubscriptionStripeId = new Set<String>();
        Map<String,Id> mapOfCustomerIDAndAccountId = new Map<String,Id>();
        Map<String,Id> mapOfSubscriptionStripeIDAndSubscriptionId = new Map<String,Id>();
        Map<wrapperForInvoice,Payment__c> mapOfWrpperAndPayment = new Map<wrapperForInvoice,Payment__c>();
        Map<wrapperForInvoice,Invoice__c> mapOfWrpperAndInvoice = new Map<wrapperForInvoice,Invoice__c>();
        if(triggerNew.size() > 0) {
            for(Webhook__c eachWebhook : triggerNew){
                if(eachWebhook.body__c != null) {
                    String jsonString =  eachWebhook.body__c.replaceAll('object','objectStripe').replaceAll('currency','currencyStripe'); 
                    listOfWrapperForInvoice.add((wrapperForInvoice)JSON.deserialize(jsonString, wrapperForInvoice.class));
                    
                }
            }
            
            if(listOfWrapperForInvoice.size() > 0) {
                for(wrapperForInvoice objWrpOfInvoice : listOfWrapperForInvoice) {
                    if(objWrpOfInvoice.data.objectStripe!=null && 
                        String.isNotBlank(objWrpOfInvoice.data.objectStripe.subscription) && 
                        (objWrpOfInvoice.type == INVOICE_TYPE_SUCCESS || 
                         objWrpOfInvoice.type == INVOICE_TYPE_FAILED)) {
                        if(objWrpOfInvoice.data.objectStripe != null) {
                            if(String.isNotBlank(objWrpOfInvoice.data.objectStripe.customer)) {
                                listAccountStripeId.add(objWrpOfInvoice.data.objectStripe.customer);
                            }
                            if(String.isNotBlank(objWrpOfInvoice.data.objectStripe.subscription)) {
                                listSubscriptionStripeId.add(objWrpOfInvoice.data.objectStripe.subscription);
                            }
                        }
                    }
                }
                if(listAccountStripeId.size() > 0){
                    for(Account objAcc : [SELECT Id, Stripe_Customer_Id__c FROM Account 
                                            WHERE Stripe_Customer_Id__c =: listAccountStripeId]) {
                        mapOfCustomerIDAndAccountId.put(objAcc.Stripe_Customer_Id__c,objAcc.Id);
                    }
                }
                if(listSubscriptionStripeId.size() > 0){
                    for(Subscription__c objSub : [SELECT Id,Stripe_Subscription_Id__c,Stripe_Sub_Scheduled_Id__c FROM Subscription__c 
                                            WHERE Stripe_Subscription_Id__c =: listSubscriptionStripeId OR 
                                            Stripe_Sub_Scheduled_Id__c =: listSubscriptionStripeId]) {
                        if(String.isNotBlank(objSub.Stripe_Subscription_Id__c)){
                            mapOfSubscriptionStripeIDAndSubscriptionId.put(objSub.Stripe_Subscription_Id__c,objSub.Id);
                        } else if(String.isNotBlank(objSub.Stripe_Sub_Scheduled_Id__c)) {
                            mapOfSubscriptionStripeIDAndSubscriptionId.put(objSub.Stripe_Sub_Scheduled_Id__c,objSub.Id);
                        }
                    }
                }
                if(listOfWrapperForInvoice.size() > 0) {
                    for(wrapperForInvoice objWrpOfInvoice : listOfWrapperForInvoice) {
                        if( String.isNotBlank(objWrpOfInvoice.data.objectStripe.subscription) && 
                            (objWrpOfInvoice.type == INVOICE_TYPE_SUCCESS || 
                            objWrpOfInvoice.type == INVOICE_TYPE_FAILED)) {
                            Invoice__c objInvoice = createInvoice(objWrpOfInvoice,mapOfCustomerIDAndAccountId,mapOfSubscriptionStripeIDAndSubscriptionId);
                            mapOfWrpperAndInvoice.put(objWrpOfInvoice,objInvoice);
                            if(objWrpOfInvoice.type == INVOICE_TYPE_SUCCESS){
                                Payment__c objPayment = createPayment(objWrpOfInvoice,mapOfCustomerIDAndAccountId,mapOfSubscriptionStripeIDAndSubscriptionId);
                                mapOfWrpperAndPayment.put(objWrpOfInvoice,objPayment);
                            }
                        }
                    }
                }
                if(mapOfWrpperAndInvoice.size() > 0) {
                    Insert mapOfWrpperAndInvoice.values();
                }
                if(mapOfWrpperAndPayment.size() > 0) {
                    for(wrapperForInvoice objWrpOfInvoice : listOfWrapperForInvoice) {
                        Payment__c objPayment =  mapOfWrpperAndPayment.get(objWrpOfInvoice);
                        if(mapOfWrpperAndInvoice.containsKey(objWrpOfInvoice)) {
                            objPayment.Invoice__c = mapOfWrpperAndInvoice.get(objWrpOfInvoice).Id;
                            mapOfWrpperAndPayment.put(objWrpOfInvoice,objPayment);
                        }
                    }
                }
                if(mapOfWrpperAndPayment.size() > 0) {
                    Insert mapOfWrpperAndPayment.values();
                }
            }
        }
    }
    //Method is used to create the Invoice
    public Invoice__c createInvoice(wrapperForInvoice objWrpOfInvoice,Map<String,Id> mapOfCustomerIDAndAccountId,Map<String,Id> mapOfSubscriptionStripeIDAndSubscriptionId){
        Invoice__c objInvoice = new Invoice__c();
        objInvoice.Sub_Total__c = objWrpOfInvoice.data.objectStripe.subtotal/100;
        objInvoice.Tax_Total__c = (objWrpOfInvoice.data.objectStripe.total - objWrpOfInvoice.data.objectStripe.subtotal)/100;
        if(objWrpOfInvoice.data.objectStripe!=null && 
            string.isNotBlank(objWrpOfInvoice.data.objectStripe.customer)){
            if(mapOfCustomerIDAndAccountId.containsKey(objWrpOfInvoice.data.objectStripe.customer)){
                objInvoice.Account__c = mapOfCustomerIDAndAccountId.get(objWrpOfInvoice.data.objectStripe.customer);
            }
            if(mapOfSubscriptionStripeIDAndSubscriptionId.containsKey(objWrpOfInvoice.data.objectStripe.subscription)){
                objInvoice.Subscription__c = mapOfSubscriptionStripeIDAndSubscriptionId.get(objWrpOfInvoice.data.objectStripe.subscription);
            }
        }
        if(objWrpOfInvoice.type == INVOICE_TYPE_SUCCESS){ 
            objInvoice.Status__c = 'Payment succeeded';
        } else {
            objInvoice.Status__c = 'Payment failed';
        }
        return objInvoice;
    }

    //Method is used to create the Payment
    public Payment__c createPayment(wrapperForInvoice objWrpOfInvoice,Map<String,Id> mapOfCustomerIDAndAccountId,Map<String,Id> mapOfSubscriptionStripeIDAndSubscriptionId){
        Payment__c objPayment = new Payment__c();
        objPayment.Payment_Id__c = objWrpOfInvoice.data.objectStripe.payment_intent;
        objPayment.Amount__c = objWrpOfInvoice.data.objectStripe.total/100;
        if(objWrpOfInvoice.data.objectStripe != null && 
            string.isNotBlank(objWrpOfInvoice.data.objectStripe.customer)){  
            if(mapOfCustomerIDAndAccountId.containsKey(objWrpOfInvoice.data.objectStripe.customer)){
                objPayment.Account__c = mapOfCustomerIDAndAccountId.get(objWrpOfInvoice.data.objectStripe.customer);
            }
            if(mapOfSubscriptionStripeIDAndSubscriptionId.containsKey(objWrpOfInvoice.data.objectStripe.subscription)){
                objPayment.Subscription__c = mapOfSubscriptionStripeIDAndSubscriptionId.get(objWrpOfInvoice.data.objectStripe.subscription);
            }
        }
        objPayment.Currency_Code__c = objWrpOfInvoice.data.objectStripe.currencyStripe;
        return objPayment;
    }
    //Wrapper Class For Invoice Json
    public class wrapperForInvoice{
    public data data;
    public String type; //invoice.payment_failed    
    }
    public class data {
        public String id;   //il_1KDvIcSE5tB6Nrkpk7nVsH0d
        public objectStripe objectStripe;  //line_item
        public Integer amount;  //50000
        public String description;  //1 × sunglass (at ₹500.00 / month)
        public boolean discountable;
        public boolean livemode;
        public boolean proration;
        public Integer quantity;    //1
        public String subscription; //sub_1KDvIcSE5tB6Nrkpvd2rOa00
        public String subscription_item;    //si_KtikYfwfhxbZvd
        public String type; //subscription*/
    }
    public class objectStripe {
        public String id;   //in_1KDvIcSE5tB6NrkpcI6l3bEd
        public String objectStripe;  //invoice
        public String account_country;  //IN
        public String account_name; //test
        public Integer amount_due;  //50000
        public Integer amount_paid; //0
        public String customer;
        public String currencyStripe;
        public Integer amount_remaining;    //50000
        public String billing_reason;   //subscription_create
        public String charge;   //ch_3KDwFBSE5tB6Nrkp0Vv0IUZ0
        public String payment_intent;   //pi_3KDwFBSE5tB6Nrkp0AjYNNMx
        public String status;   //open
        public String subscription; //sub_1KDvIcSE5tB6Nrkpvd2rOa00
        public Integer subtotal;    //50000
        //public Integer tax;
        public Integer total;   //50000
        }
}