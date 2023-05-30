@isTest
global class MockHttpResponseGeneratorCreate implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
       
        
		String Apikey = 'sk_test_51Jz2MJSDdfL2No7pI9cHJmBtLwReGSPynyCkEjUdLXcUYxx9sOdmiadMY3TQf7PjnbIvsAu7gPiLyA6tNYrmFp8k00otexy4CV';
        String priceId = 'price_1K0IauSDdfL2No7pz9knrsyV';
        String customerId = 'cus_Ket7WVZtAq9O4l';
        String subscriptionId = 'sub_1K1bIISDdfL2No7pLLtjnar0';
        String paymentMethodId = 'card_1K1xG2SJhC5U83eHnrZds9IB';
        long startDate = 1670347347;
        long endDate = 1701883347;
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Authorization', 'Bearer '+Apikey);
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String params = 'phases[0][items][0][price]='+priceId+'&customer='+customerId +'&phases[0][default_payment_method]='+paymentMethodId +'&start_date='+startDate+'&phases[0][end_date]='+endDate;
        res.setBody(params);
        res.setStatusCode(200);
        return res;
        
    }
}