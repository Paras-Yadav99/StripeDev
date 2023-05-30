@isTest
public class sendPaymentControllerTest {
    @isTest(SeeAllData=false)
    public static void testMethod1(){
        Account objAccount = new Account();
        objAccount.name='Test Account';
        objAccount.Stripe_Customer_Id__c='cus_KjEA4otq5XervY';
        insert objAccount;
        
        Payment_Method__c objPaymentMethod = new Payment_Method__c();
        objPaymentMethod.Account__c = objAccount.Id;
        objPaymentMethod.Card_Number__c = '4242424242424242';
        objPaymentMethod.Card_Expiry_Month__c=06;
        objPaymentMethod.card_Expiry_Year__c=2025;
        objPaymentMethod.is_Default__c = true;
        objPaymentMethod.Payment_Method_Id__c='pm_1K6AwnSJhC5U83eHjNXWBQNa';
        Insert objPaymentMethod;
        
        Payment__c objPayment = new Payment__c();
        objPayment.Amount__c = 200;
        objPayment.Currency_Code__c='inr';
        objPayment.Description__c ='test Description';
        objPayment.Payment_Method__c = objPaymentMethod.Id;
        objPayment.Account__c = objAccount.Id;
        Insert objPayment;
        
        sendPaymentController.wrapper wrapper = new sendPaymentController.wrapper(1000,
                                                                                 'inr',
                                                                                 'test',
                                                                                 'PM_1234',
                                                                                 '12312');
        
        String wrapperString = JSON.serialize(wrapper); 
        
        Test.setMock(HttpCalloutMock.class, new MockClassForStripe());
        
        Test.startTest();
        
        string key = StripeIntegrationHelper.getSecretKey();
        stripePaymentInitiationServiceHelper stripe = new stripePaymentInitiationServiceHelper(key);
        APIresponse APIresponse=stripe.createPaymentInitiationInStripe(objPayment.Amount__c,
                                                                       objPayment.Currency_Code__c,
                                                                       objAccount.Stripe_Customer_Id__c,
                                                                       objPayment.Description__c,
                                                                       objPaymentMethod.Payment_Method_Id__c);
        
        system.debug('APIresponse'+APIresponse);
        Test.StopTest();
        sendPaymentController.search('Account',
                                    new list<string>{'Name'},
                                    'abc',
                                    '1234');
        
        sendPaymentController.createPayment(wrapperString,
                                            objAccount.Id,
                                            objAccount.Stripe_Customer_Id__c);
        sendPaymentController.createSendMethod(objPayment.Amount__c,
                                               objPayment.Currency_Code__c,
                                               objPayment.Description__c,
                                               String.valueOf(APIresponse.response),
                                               String.valueOf(objAccount.Id),
                                               String.valueOf(objPaymentMethod.Payment_Method_Id__c));
        
        sendPaymentController.wrapper objWrap = new sendPaymentController.wrapper(objPayment.Amount__c,
                                                                                  objPayment.Currency_Code__c,
                                                                                  objPayment.Description__c,
                                                                                  objPaymentMethod.Payment_Method_Id__c,
                                                                                  objAccount.Stripe_Customer_Id__c);
        
    }
}