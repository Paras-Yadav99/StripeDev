@isTest
global class MockHttpResponseGeneratorDelete implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        String subId = 'sub_1K1vZlSDdfL2No7p8yuUdNon';
        String Apikey = 'sk_test_51Jz2MJSDdfL2No7pI9cHJmBtLwReGSPynyCkEjUdLXcUYxx9sOdmiadMY3TQf7PjnbIvsAu7gPiLyA6tNYrmFp8k00otexy4CV';
		String sub_schdId = 'sub_sched_1K2TdzSDdfL2No7pm8Arjkhy';
        system.debug('req.getEndpoint()'+req.getEndpoint());
        System.assertEquals('https://api.stripe.com/v1/subscription_schedules/'+sub_schdId+'/cancel', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Authorization', 'Bearer '+Apikey);
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        res.setStatusCode(200);
        return res;
        
    }
}