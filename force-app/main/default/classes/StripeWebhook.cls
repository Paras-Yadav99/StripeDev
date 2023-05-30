@RestResource(urlMapping='/api/webhooks/incoming/stripe/*')
global with sharing class StripeWebhook {
    @HttpPost
    global static void handleNotification(){
        RestRequest request = RestContext.request;
        Blob requestBody = request.requestBody;
        
        Webhook__c hook = new Webhook__c();
        if (Schema.sObjectType.Contact.fields.Email.isCreateable()) {
   			hook.body__c = EncodingUtil.base64Decode(EncodingUtil.base64Encode(request.requestBody)).toString();
        
        }
        
        if(Schema.sObjectType.Webhook__c.isCreateable()) {
            insert(hook);
        }
        
        
    }
}