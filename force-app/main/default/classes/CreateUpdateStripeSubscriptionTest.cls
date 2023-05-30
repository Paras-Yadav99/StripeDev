@isTest()
public class CreateUpdateStripeSubscriptionTest {
    @isTest static void testCallout() {
        
        Subscription__c sub1 = new Subscription__c();
        sub1.isActive__c = true;
		Id subId = sub1.id;    
        
        String Apikey = 'sk_test_51Jz2MJSDdfL2No7pI9cHJmBtLwReGSPynyCkEjUdLXcUYxx9sOdmiadMY3TQf7PjnbIvsAu7gPiLyA6tNYrmFp8k00otexy4CV';
        String priceId = 'price_1K0IauSDdfL2No7pz9knrsyV';
        String customerId = 'cus_Ket7WVZtAq9O4l';
        Long startDate = 27/10/2021;
        Long endDate = 27/10/2021;
        String  subscriptionId = 'sub_1K1bIISDdfL2No7pLLtjnar0';
        String paymentMethodId = 'pm_1K1FZHSJhC5U83eHApCyTlt8';
        String scheudSubscriptionId = 'sub_sched_1K2TdzSDdfL2No7pm8Arjkhy';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorCreate());
        CreateUpdateStripeSubscription.scheduleSubscription(subId, Apikey, priceId, customerId, paymentMethodId, startDate, endDate);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorUpdate());
        CreateUpdateStripeSubscription.updatescheduleSubscription(subId, Apikey, subscriptionId, scheudSubscriptionId,priceId, paymentMethodId, startDate, endDate);
        
    
    }
  
}