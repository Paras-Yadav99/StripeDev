trigger WebhookTrigger on Webhook__c (              before update,
                                                    after insert,
                                                    after update,
                                                    before delete,
                                                    after delete) {

    TriggerDispatcher.run(new WebhookTriggerHandler(), 'WebhookTrigger');
}