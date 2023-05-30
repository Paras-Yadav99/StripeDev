public class SubscriptionTriggerHandler implements ITriggerHandler{

    public static Boolean TriggerDisabled = false;
    public static final string ERROR_NO_DEFAULT_PAYMENT_METHOD = 'Default Payment Method is not found';
    Map<Id,SObject> oldMap;
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public  void beforeInsert(List<sObject> listofCompanyUser) {
        
        
    }
    
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) 
    {	
        Set<Id> setSubscriptionIds = new Set<Id>();
        for(Subscription__c sub : (List<Subscription__c>)newList){
            if(sub.isActive__c &&
              	string.isNotBlank(sub.Price_Stripe_Id__c ) ) {
                  setSubscriptionIds.add(sub.Id);
              }
        }
        // Call Create Subscription API
        if(!Test.isRunningTest() && setSubscriptionIds!=null && !setSubscriptionIds.isEmpty()) {
            createSubScriptionMethod(setSubscriptionIds);
        }
        
    }  
    
    public  void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
        
        
    }
    
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) 
    {
       
       	afterUpdateandProcess(oldMap, newList);
		    
    }
    
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap) 
    {
           
    }
        
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) 
    {
        
    }
    
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
        
    }
    
    @future(callout=true)
    public static void createSubScriptionMethod(Set<Id> setIds){
        string key = StripeIntegrationHelper.getSecretKey();
        if(Test.isRunningTest()){
            //do something
        }else{
            StripeIntegrationHelper.createSubScriptionMethod(key, setIds);
        }
    }
    
    @future(callout=true)
    public static void updateSubscriptionMethod(Set<Id> setIds){
        string key = StripeIntegrationHelper.getSecretKey();
        
        StripeIntegrationHelper.updateSubscriptionMethod(key, setIds);
    }
    
    @future(callout=true)
    public static void deleteSubscriptionMethod(Set<Id> setIds){
        string key = StripeIntegrationHelper.getSecretKey();
        
        StripeIntegrationHelper.deleteSubscriptionMethod(key, setIds);
    }
    
    public void afterUpdateandProcess(Map<Id, sObject> oldMap, List<sObject> newList){
         set<Id> setSubscriptionUpdateIds = new Set<Id>();
        set<Id> setSubscriptionInsertIds = new Set<Id>();
        set<Id> setSubscriptionDeleteIds = new Set<Id>();
        Map<Id, Subscription__c> oldMapSubscription =  (Map<Id, Subscription__c>)oldMap;
        
        for(Subscription__c sub : (List<Subscription__c>)newList){
            
            if(oldMapSubscription.get(sub.Id).isActive__c != sub.isActive__c){
                if(sub.isActive__c && String.isBlank(sub.Stripe_Subscription_Id__c)){
                    
                    setSubscriptionInsertIds.add(sub.Id);
                    
                } else if(sub.isActive__c && 
                          String.isNotBlank(sub.Stripe_Subscription_Id__c)){
                    
                    setSubscriptionUpdateIds.add(sub.Id);
                    
                } else if(!sub.isActive__c){
                    setSubscriptionDeleteIds.add(sub.Id);
                    
                } 
            }
            if(oldMapSubscription.get(sub.Id).Start_Date__c != sub.Start_Date__c ||
              oldMapSubscription.get(sub.Id).End_Date__c != sub.End_Date__c){
                
                setSubscriptionUpdateIds.add(sub.Id);
                
            }
            
        }
        
        if(!setSubscriptionUpdateIds.isEmpty()) {
            updateSubscriptionMethod(setSubscriptionUpdateIds);
        }
        
        if(!setSubscriptionDeleteIds.isEmpty()) {
            deleteSubscriptionMethod(setSubscriptionDeleteIds);
        }
        
        if(!setSubscriptionInsertIds.isEmpty()) {
            createSubScriptionMethod(setSubscriptionInsertIds);
        }
        
        
    }
}