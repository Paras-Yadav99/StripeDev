public class JSON2Apex {
 
	/*public class Recurring {
		public Object aggregate_usage {get;set;} 
		public String interval {get;set;} 
		public Integer interval_count {get;set;} 
		public Object trial_period_days {get;set;} 
		public String usage_type {get;set;} 

		public Recurring(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'aggregate_usage') {
							aggregate_usage = parser.readValueAs(Object.class);
						} else if (text == 'interval') {
							interval = parser.getText();
						} else if (text == 'interval_count') {
							interval_count = parser.getIntegerValue();
						} else if (text == 'trial_period_days') {
							trial_period_days = parser.readValueAs(Object.class);
						} else if (text == 'usage_type') {
							usage_type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Recurring consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data_Z {
		public String id {get;set;} 
		public String object_Z {get;set;} // in json: object
		public Object application_fee_percent {get;set;} 
		public Automatic_tax automatic_tax {get;set;} 
		public Integer billing_cycle_anchor {get;set;} 
		public Object billing_thresholds {get;set;} 
		public Object cancel_at {get;set;} 
		public Boolean cancel_at_period_end {get;set;} 
		public Object canceled_at {get;set;} 
		public String collection_method {get;set;} 
		public Integer created {get;set;} 
		public Integer current_period_end {get;set;} 
		public Integer current_period_start {get;set;} 
		public String customer {get;set;} 
		public Object days_until_due {get;set;} 
		public String default_payment_method {get;set;} 
		public Object default_source {get;set;} 
		public List<Default_tax_rates> default_tax_rates {get;set;} 
		public Object discount {get;set;} 
		public Object ended_at {get;set;} 
		public Items items {get;set;} 
		public String latest_invoice {get;set;} 
		public Boolean livemode {get;set;} 
		public Default_tax_rates metadata {get;set;} 
		public Object next_pending_invoice_item_invoice {get;set;} 
		public Object pause_collection {get;set;} 
		public Payment_settings payment_settings {get;set;} 
		public Object pending_invoice_item_interval {get;set;} 
		public Object pending_setup_intent {get;set;} 
		public Object pending_update {get;set;} 
		public Plan plan {get;set;} 
		public Integer quantity {get;set;} 
		public Object schedule {get;set;} 
		public Integer start_date {get;set;} 
		public String status {get;set;} 
		public Object transfer_data {get;set;} 
		public Object trial_end {get;set;} 
		public Object trial_start {get;set;} 

		public Data_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'object') {
							object_Z = parser.getText();
						} else if (text == 'application_fee_percent') {
							application_fee_percent = parser.readValueAs(Object.class);
						} else if (text == 'automatic_tax') {
							automatic_tax = new Automatic_tax(parser);
						} else if (text == 'billing_cycle_anchor') {
							billing_cycle_anchor = parser.getIntegerValue();
						} else if (text == 'billing_thresholds') {
							billing_thresholds = parser.readValueAs(Object.class);
						} else if (text == 'cancel_at') {
							cancel_at = parser.readValueAs(Object.class);
						} else if (text == 'cancel_at_period_end') {
							cancel_at_period_end = parser.getBooleanValue();
						} else if (text == 'canceled_at') {
							canceled_at = parser.readValueAs(Object.class);
						} else if (text == 'collection_method') {
							collection_method = parser.getText();
						} else if (text == 'created') {
							created = parser.getIntegerValue();
						} else if (text == 'current_period_end') {
							current_period_end = parser.getIntegerValue();
						} else if (text == 'current_period_start') {
							current_period_start = parser.getIntegerValue();
						} else if (text == 'customer') {
							customer = parser.getText();
						} else if (text == 'days_until_due') {
							days_until_due = parser.readValueAs(Object.class);
						} else if (text == 'default_payment_method') {
							default_payment_method = parser.getText();
						} else if (text == 'default_source') {
							default_source = parser.readValueAs(Object.class);
						} else if (text == 'default_tax_rates') {
							default_tax_rates = arrayOfDefault_tax_rates(parser);
						} else if (text == 'discount') {
							discount = parser.readValueAs(Object.class);
						} else if (text == 'ended_at') {
							ended_at = parser.readValueAs(Object.class);
						} else if (text == 'items') {
							items = new Items(parser);
						} else if (text == 'latest_invoice') {
							latest_invoice = parser.getText();
						} else if (text == 'livemode') {
							livemode = parser.getBooleanValue();
						} else if (text == 'metadata') {
							metadata = new Default_tax_rates(parser);
						} else if (text == 'next_pending_invoice_item_invoice') {
							next_pending_invoice_item_invoice = parser.readValueAs(Object.class);
						} else if (text == 'pause_collection') {
							pause_collection = parser.readValueAs(Object.class);
						} else if (text == 'payment_settings') {
							payment_settings = new Payment_settings(parser);
						} else if (text == 'pending_invoice_item_interval') {
							pending_invoice_item_interval = parser.readValueAs(Object.class);
						} else if (text == 'pending_setup_intent') {
							pending_setup_intent = parser.readValueAs(Object.class);
						} else if (text == 'pending_update') {
							pending_update = parser.readValueAs(Object.class);
						} else if (text == 'plan') {
							plan = new Plan(parser);
						} else if (text == 'quantity') {
							quantity = parser.getIntegerValue();
						} else if (text == 'schedule') {
							schedule = parser.readValueAs(Object.class);
						} else if (text == 'start_date') {
							start_date = parser.getIntegerValue();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'transfer_data') {
							transfer_data = parser.readValueAs(Object.class);
						} else if (text == 'trial_end') {
							trial_end = parser.readValueAs(Object.class);
						} else if (text == 'trial_start') {
							trial_start = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'Data_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String object_Z {get;set;} // in json: object
	public List<Data_Z> data {get;set;} 
	public Boolean has_more {get;set;} 
	public String url {get;set;} 

	public JSON2Apex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'object') {
						object_Z = parser.getText();
					} else if (text == 'data') {
						data = arrayOfData_Z(parser);
					} else if (text == 'has_more') {
						has_more = parser.getBooleanValue();
					} else if (text == 'url') {
						url = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Automatic_tax {
		public Boolean enabled {get;set;} 

		public Automatic_tax(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'enabled') {
							enabled = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Automatic_tax consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Price {
		public String id {get;set;} 
		public String object_Z {get;set;} // in json: object
		public Boolean active {get;set;} 
		public String billing_scheme {get;set;} 
		public Integer created {get;set;} 
		public String currency_Z {get;set;} // in json: currency
		public Boolean livemode {get;set;} 
		public Object lookup_key {get;set;} 
		public Default_tax_rates metadata {get;set;} 
		public Object nickname {get;set;} 
		public String product {get;set;} 
		public Recurring recurring {get;set;} 
		public String tax_behavior {get;set;} 
		public Object tiers_mode {get;set;} 
		public Object transform_quantity {get;set;} 
		public String type {get;set;} 
		public Integer unit_amount {get;set;} 
		public String unit_amount_decimal {get;set;} 

		public Price(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'object') {
							object_Z = parser.getText();
						} else if (text == 'active') {
							active = parser.getBooleanValue();
						} else if (text == 'billing_scheme') {
							billing_scheme = parser.getText();
						} else if (text == 'created') {
							created = parser.getIntegerValue();
						} else if (text == 'currency') {
							currency_Z = parser.getText();
						} else if (text == 'livemode') {
							livemode = parser.getBooleanValue();
						} else if (text == 'lookup_key') {
							lookup_key = parser.readValueAs(Object.class);
						} else if (text == 'metadata') {
							metadata = new Default_tax_rates(parser);
						} else if (text == 'nickname') {
							nickname = parser.readValueAs(Object.class);
						} else if (text == 'product') {
							product = parser.getText();
						} else if (text == 'recurring') {
							recurring = new Recurring(parser);
						} else if (text == 'tax_behavior') {
							tax_behavior = parser.getText();
						} else if (text == 'tiers_mode') {
							tiers_mode = parser.readValueAs(Object.class);
						} else if (text == 'transform_quantity') {
							transform_quantity = parser.readValueAs(Object.class);
						} else if (text == 'type') {
							type = parser.getText();
						} else if (text == 'unit_amount') {
							unit_amount = parser.getIntegerValue();
						} else if (text == 'unit_amount_decimal') {
							unit_amount_decimal = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Price consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Default_tax_rates {

		public Default_tax_rates(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Default_tax_rates consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public String id {get;set;} 
		public String object_Z {get;set;} // in json: object
		public Object billing_thresholds {get;set;} 
		public Integer created {get;set;} 
		public Default_tax_rates metadata {get;set;} 
		public Plan plan {get;set;} 
		public Price price {get;set;} 
		public Integer quantity {get;set;} 
		public String subscription {get;set;} 
		public List<Default_tax_rates> tax_rates {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'object') {
							object_Z = parser.getText();
						} else if (text == 'billing_thresholds') {
							billing_thresholds = parser.readValueAs(Object.class);
						} else if (text == 'created') {
							created = parser.getIntegerValue();
						} else if (text == 'metadata') {
							metadata = new Default_tax_rates(parser);
						} else if (text == 'plan') {
							plan = new Plan(parser);
						} else if (text == 'price') {
							price = new Price(parser);
						} else if (text == 'quantity') {
							quantity = parser.getIntegerValue();
						} else if (text == 'subscription') {
							subscription = parser.getText();
						} else if (text == 'tax_rates') {
							tax_rates = arrayOfDefault_tax_rates(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Items {
		public String object_Z {get;set;} // in json: object
		public List<Data> data {get;set;} 
		public Boolean has_more {get;set;} 
		public Integer total_count {get;set;} 
		public String url {get;set;} 

		public Items(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'object') {
							object_Z = parser.getText();
						} else if (text == 'data') {
							data = arrayOfData(parser);
						} else if (text == 'has_more') {
							has_more = parser.getBooleanValue();
						} else if (text == 'total_count') {
							total_count = parser.getIntegerValue();
						} else if (text == 'url') {
							url = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Items consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Plan {
		public String id {get;set;} 
		public String object_Z {get;set;} // in json: object
		public Boolean active {get;set;} 
		public Object aggregate_usage {get;set;} 
		public Integer amount {get;set;} 
		public String amount_decimal {get;set;} 
		public String billing_scheme {get;set;} 
		public Integer created {get;set;} 
		public String currency_Z {get;set;} // in json: currency
		public String interval {get;set;} 
		public Integer interval_count {get;set;} 
		public Boolean livemode {get;set;} 
		public Default_tax_rates metadata {get;set;} 
		public Object nickname {get;set;} 
		public String product {get;set;} 
		public Object tiers_mode {get;set;} 
		public Object transform_usage {get;set;} 
		public Object trial_period_days {get;set;} 
		public String usage_type {get;set;} 

		public Plan(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'object') {
							object_Z = parser.getText();
						} else if (text == 'active') {
							active = parser.getBooleanValue();
						} else if (text == 'aggregate_usage') {
							aggregate_usage = parser.readValueAs(Object.class);
						} else if (text == 'amount') {
							amount = parser.getIntegerValue();
						} else if (text == 'amount_decimal') {
							amount_decimal = parser.getText();
						} else if (text == 'billing_scheme') {
							billing_scheme = parser.getText();
						} else if (text == 'created') {
							created = parser.getIntegerValue();
						} else if (text == 'currency') {
							currency_Z = parser.getText();
						} else if (text == 'interval') {
							interval = parser.getText();
						} else if (text == 'interval_count') {
							interval_count = parser.getIntegerValue();
						} else if (text == 'livemode') {
							livemode = parser.getBooleanValue();
						} else if (text == 'metadata') {
							metadata = new Default_tax_rates(parser);
						} else if (text == 'nickname') {
							nickname = parser.readValueAs(Object.class);
						} else if (text == 'product') {
							product = parser.getText();
						} else if (text == 'tiers_mode') {
							tiers_mode = parser.readValueAs(Object.class);
						} else if (text == 'transform_usage') {
							transform_usage = parser.readValueAs(Object.class);
						} else if (text == 'trial_period_days') {
							trial_period_days = parser.readValueAs(Object.class);
						} else if (text == 'usage_type') {
							usage_type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Plan consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Payment_settings {
		public Object payment_method_options {get;set;} 
		public Object payment_method_types {get;set;} 

		public Payment_settings(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'payment_method_options') {
							payment_method_options = parser.readValueAs(Object.class);
						} else if (text == 'payment_method_types') {
							payment_method_types = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'Payment_settings consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static JSON2Apex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSON2Apex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<Data_Z> arrayOfData_Z(System.JSONParser p) {
        List<Data_Z> res = new List<Data_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data_Z(p));
        }
        return res;
    }






    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }





    private static List<Default_tax_rates> arrayOfDefault_tax_rates(System.JSONParser p) {
        List<Default_tax_rates> res = new List<Default_tax_rates>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Default_tax_rates(p));
        }
        return res;
    }



    
   /* {
    "object": "list",
    "data": [
        {
            "customer": "cus_Ket7WVZtAq9O4l",
            "items": {
                "data": [
                    {
                        "price": {
                            "id": "price_1K0IauSDdfL2No7pz9knrsyV",
                            "product": "prod_Kfdsi93BsQRFay"
                        }
                    }
                ]
            }
            
        }
    ]
    
} */




}