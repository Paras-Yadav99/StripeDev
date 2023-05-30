@isTest()
public class SubscriptionTriggerTest {
    
    
    public static testMethod void testFirst() {
        
        date myDateOld = date.newInstance(2021, 01, 21);
        date myDateNew = myDateOld.addMonths(3);
        date myDateOld1 = date.newInstance(2021, 02, 21);
        date myDateNew1 = myDateOld.addMonths(3);
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Stripe_Customer_Id__c = 'test';
        Insert acc;
        
        Payment_Method__c paymentmethod = new Payment_Method__c();
        paymentmethod.Account__c = acc.id;
        paymentmethod.is_Default__c = true;
		insert paymentmethod;
        
        List<Subscription__c> subscriptionList = new List<Subscription__c>();
        Set<Id> subsIdSet = new Set<Id>();
        Subscription__c sub1 = new Subscription__c();
        sub1.isActive__c = true;
        sub1.Start_Date__c = myDateOld;
        sub1.End_Date__c =  myDateNew;
        sub1.Account__c = acc.id;
        subscriptionList.add(sub1);
        subsIdSet.add(sub1.id);
        
        Subscription__c sub2 = new Subscription__c();
        sub2.isActive__c = false;
        sub2.Start_Date__c = myDateNew1;
        sub2.End_Date__c =  myDateOld1;
        sub2.Account__c = acc.id;
        subscriptionList.add(sub2);
        subsIdSet.add(sub2.id);
        insert subscriptionList;
        update subscriptionList;
        delete subscriptionList;
       
         List<Subscription__c> lstSub = [SELECT Id,
                                        		Account__c,
                                        		Name, 
                                        		Price__c,
                                        		End_Date__c,
                                        		Start_Date__c,
                                        		isActive__c FROM Subscription__c WHERE ID IN: subsIdSet];
        

        
        
        
        Map<Id, Subscription__c> subMapNew = new  Map<Id, Subscription__c>();
        subMapNew.put(sub1.id, sub1);
        subMapNew.put(sub2.id, sub2);
        
        Map<Id, Subscription__c> subMapOld = new  Map<Id, Subscription__c>();
        subMapOld.put(sub2.id, sub2);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorCreate());
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorUpdate());
        
        SubscriptionTriggerHandler objSubscriptionTriggerHandler = new SubscriptionTriggerHandler();
        objSubscriptionTriggerHandler.isDisabled();
        objSubscriptionTriggerHandler.afterDelete(subscriptionList, subMapOld);
        objSubscriptionTriggerHandler.afterInsert(subscriptionList, subMapNew);
        objSubscriptionTriggerHandler.afterUnDelete(subscriptionList, subMapNew);
        //objSubscriptionTriggerHandler.afterUpdate(subscriptionList, subMapNew, subscriptionList, subMapOld);
        objSubscriptionTriggerHandler.beforeDelete(subscriptionList, subMapOld);
        objSubscriptionTriggerHandler.beforeInsert(subscriptionList);
        objSubscriptionTriggerHandler.beforeUpdate(subscriptionList, subMapNew, subscriptionList, subMapOld);
        
       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorCreate());
      //  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorUpdate());

        //  objSubscriptionTriggerHandler.createSubScriptionMethod(subsIdSet);
       // objSubscriptionTriggerHandler.deleteSubscriptionMethod();
       
    }
    public static testMethod void testSecond(){
        
        date myDateOld = date.newInstance(2021, 01, 21);
        date myDateNew = myDateOld.addMonths(3);
        date myDateOld1 = date.newInstance(2021, 02, 21);
        date myDateNew1 = myDateOld.addMonths(3);
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Stripe_Customer_Id__c = 'test';
        Insert acc;
        
        Payment_Method__c paymentmethod = new Payment_Method__c();
        paymentmethod.Account__c = acc.id;
        paymentmethod.is_Default__c = true;
		insert paymentmethod;
        
        List<Subscription__c> subscriptionList = new List<Subscription__c>();
        Set<Id> subsIdSet = new Set<Id>();
        Subscription__c sub1 = new Subscription__c();
        sub1.isActive__c = false;
        sub1.Start_Date__c = myDateOld;
        sub1.End_Date__c =  myDateNew;
        sub1.Account__c = acc.id;
        subscriptionList.add(sub1);
        subsIdSet.add(sub1.id);
        
        Subscription__c sub2 = new Subscription__c();
        sub2.isActive__c = true;
        sub2.Start_Date__c = myDateNew1;
        sub2.End_Date__c =  myDateOld1;
        sub2.Account__c = acc.id;
        subscriptionList.add(sub2);
        subsIdSet.add(sub2.id);
       
                
        Map<Id, Subscription__c> subMapNew = new  Map<Id, Subscription__c>();
        subMapNew.put(sub1.id, sub1);
        subMapNew.put(sub2.id, sub2);
        
        Map<Id, Subscription__c> subMapOld = new  Map<Id, Subscription__c>();
        subMapOld.put(sub2.id, sub2);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorUpdate());
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorDelete());
        
        SubscriptionTriggerHandler objSubscriptionTriggerHandler = new SubscriptionTriggerHandler();
        objSubscriptionTriggerHandler.isDisabled();
        objSubscriptionTriggerHandler.afterUpdate(subscriptionList, subMapNew, subscriptionList, subMapOld);
    
      
        
        
    }   
}