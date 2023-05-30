trigger SubscriptionTrigger on Subscription__c (before insert,
                                                    before update,
                                                    after insert,
                                                    after update,
                                                    before delete,
                                                    after delete) {
                                                        
                                                        TriggerDispatcher.run(new SubscriptionTriggerHandler(), 'SubscriptionTrigger');
    
  
}