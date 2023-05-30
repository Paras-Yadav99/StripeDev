@isTest
public class createPaymentMethodControllerTest {        
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
        objPaymentMethod.CVV__c=123;
        //objPaymentMethod.is_Default__c = true;
        objPaymentMethod.Payment_Method_Id__c='pm_1K6AwnSJhC5U83eHjNXWBQNa';
        Insert objPaymentMethod;
        
        Payment__c objPayment = new Payment__c();
        objPayment.Amount__c = 200;
        objPayment.Currency_Code__c='inr';
        objPayment.Description__c ='test Description';
        objPayment.Payment_Method__c = objPaymentMethod.Id;
        objPayment.Account__c = objAccount.Id;
        Insert objPayment;
        
        String str = JSON.serialize(objPaymentMethod); 
        
        createPaymentMethodController.wrapper wrapClass = new createPaymentMethodController.wrapper('',
                                                                                                    objPaymentMethod.Card_Number__c,
                                                                                                    'Test',
                                                                                                    'dev@gmail.com',
                                                                                                    Integer.valueOf(objPaymentMethod.Card_Expiry_Month__c),
                                                                                                    Integer.valueOf(objPaymentMethod.card_Expiry_Year__c),
                                                                                                    objPayment.Amount__c,
                                                                                                    objPayment.Currency_Code__c,
                                                                                                    'MasterCard',
                                                                                                    objPayment.Description__c,
                                                                                                    objAccount.Stripe_Customer_Id__c,
                                                                                                    'Visa',
                                                                                                    Integer.valueOf(objPaymentMethod.CVV__c),
                                                                                                    true
                                                                                                   );
        createPaymentMethodController.createPaymentMethod(str,objAccount.Id);
        
        Test.setMock(HttpCalloutMock.class, new MockClassForStripe());
        
        Test.startTest();       
        createPaymentMethodController.AuraResponse newAuraResponse = createPaymentMethodController.hitPaymentMeethodAPI(wrapClass,objAccount.Id);
        
        system.assertEquals('SUCCESS',newAuraResponse.message);
        Test.StopTest();
    }
}