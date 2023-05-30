@isTest
global class MockHttpResponseGeneratorUpdate implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        String subscriptionId = 'sub_1K1bIISDdfL2No7pLLtjnar0';
        
        
		String Apikey = 'sk_test_51Jz2MJSDdfL2No7pI9cHJmBtLwReGSPynyCkEjUdLXcUYxx9sOdmiadMY3TQf7PjnbIvsAu7gPiLyA6tNYrmFp8k00otexy4CV';
        String priceId = 'price_1K0IauSDdfL2No7pz9knrsyV';
        String customerId = 'cus_Ket7WVZtAq9O4l';
        String subscriptnId = 'sub_1K1bIISDdfL2No7pLLtjnar0';
        String paymentMethodId = 'card_1K1xG2SJhC5U83eHnrZds9IB';
        long startDate = 1670347347;
        long endDate = 1701883347;
        String sub_schdId = 'sub_sched_1K2TdzSDdfL2No7pm8Arjkhy';

        String params = '&&phases[0][start_date]='+startDate+'&phases[0][end_date]='+endDate+'&phases[0][items][0][price]='+priceId+'&phases[0][items][0][quantity]=1';
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Authorization', 'Bearer '+Apikey);
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        res.setStatusCode(200);
        return res;
        
    }
}