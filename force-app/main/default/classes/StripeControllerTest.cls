@isTest
public with sharing class StripeControllerTest {
    
    @TestSetup
    static void loadData(){
        
    }
    
    @isTest
    public static void testgetData(){
        
        StripePaymentForCustomerController.wrapper wrapper = new StripePaymentForCustomerController.wrapper(null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null,
                                                                                                            null
                                                                                                           );
        StripePaymentForCustomerController.AuraResponse AuraResponse = new StripePaymentForCustomerController.AuraResponse(null,null,null);
        
        
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockClassForStripe());
        
        StripePaymentForCustomerController.AuraResponse AuraResponse1 =StripePaymentForCustomerController.chargeUsingStripe(JSON.serialize(wrapper));
        system.assertEquals('ERROR', AuraResponse1.message);
        //system.debug('AuraResponse1'+AuraResponse1);
        Test.stopTest();
        StripePaymentForCustomerController.saveData(AuraResponse.response);
    }
    public static testmethod void createSubScriptionMethodTest()
    {
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
        
        
        Subscription__c sub2 = new Subscription__c();
        sub2.isActive__c = true;
        sub2.Start_Date__c = myDateNew1;
        sub2.End_Date__c =  myDateOld1;
        sub2.Account__c = acc.id;
        subscriptionList.add(sub2);
        insert subscriptionList;
        for(Subscription__c sub : subscriptionList)
        {
            subsIdSet.add(sub.Id);
        }
        Test.setMock(HTTPCalloutMock.class, new MockClassForStripe());
        Test.startTest();
        StripeIntegrationHelper.createSubScriptionMethod('test', subsIdSet);
        StripeIntegrationHelper.updateSubscriptionMethod('test', subsIdSet);
        StripeIntegrationHelper.deleteSubscriptionMethod('test', subsIdSet);
        
        //System.assertEquals(-23.33,celsius);
        
        Test.stopTest();
        
    }
    
}