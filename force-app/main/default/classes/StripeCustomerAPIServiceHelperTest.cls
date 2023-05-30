@isTest
public without sharing class StripeCustomerAPIServiceHelperTest {
    
    @isTest
    public static void testCustomerService() {
        Test.startTest();
        // Setting up the mock response
        Test.setMock(HTTPCalloutMock.class, new MockClassForStripe());
        // Performing the API callout
        StripeCustomerAPIServiceHelper StripeCustomerAPIServiceHelper = new StripeCustomerAPIServiceHelper('sadasdsa');
        StripeCustomerAPIServiceHelper.createCustomerInStripe('test@gmail.com',
                                                                                        'description',
                                                                                        'Sanjeet');
        
        Test.stopTest();
    }

    @isTest
    public static void testPayment() {
        Test.startTest();
        // Setting up the mock response
        Test.setMock(HTTPCalloutMock.class, new MockClassForStripe());
        // Performing the API callout
        StripePayment StripePayment = new StripePayment('sadasdsa');
        StripePayment.createPaymentMethodInStripe('type',
                                                    'cardnumber',
                                                    2023,
                                                    23,
                                                    'abcd',
                                                    'pID',
                                                    false);
        
        Test.stopTest();
    }

    @isTest
    public static void testPaymentForAttaching() {
        Test.startTest();
        // Setting up the mock response
        Test.setMock(HTTPCalloutMock.class, new MockClassForStripe());
        // Performing the API callout
        StripePayment StripePayment = new StripePayment('sadasdsa');
        StripePayment.createPaymentMethodInStripe('type',
                                                    'cardnumber',
                                                    2023,
                                                    23,
                                                    'abcd',
                                                    'pID',
                                                    true);
        
        Test.stopTest();
    }

    @isTest
    public static void testPaymentInitiate() {
        Test.startTest();
        // Setting up the mock response
        Test.setMock(HTTPCalloutMock.class, new MockClassForStripe());
        // Performing the API callout
        stripePaymentInitiationServiceHelper stripePaymentInitiationServiceHelper = new stripePaymentInitiationServiceHelper('sadasdsa');
        stripePaymentInitiationServiceHelper.createPaymentInitiationInStripe(1000,
                                                                            'inr',
                                                                            'llllllllll',
                                                                            'description',
                                                                            'paymentMethodId');
        
        Test.stopTest();
    }

}