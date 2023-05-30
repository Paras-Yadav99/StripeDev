@isTest
global with sharing class MockClassForStripe implements HTTPCalloutMock {
    // Creating a fake response
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        // Setting the response body
        response.setBody('{"id": "sk_sdsdsddsdssdsdsds"}');
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody(JSON.serialize(new Map<string,string>()));
        return response;
    }

}