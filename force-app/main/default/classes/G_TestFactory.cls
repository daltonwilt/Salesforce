/**
 * A utility class for building needed data when creating your test classes.
 * 
 * @author            : dalton@outlook.com
 * @last modified on  : 9/15/2025
 * @last modified by  : dalton@outlook.com
 * @todo
 */
@isTest
global class G_TestFactory {

    public static String mockResponse = '{"message":"Success Response", "data":[{}]}';
    public static Integer mockStatusCode = 200;

    // *************************************************************
    // * The following methods are for Standard Objects
    // *************************************************************

    public static Map<String, Object> generateAccount(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Account a = new Account(Name = 'Account Test');
        insert a;

        resultMap.put('result', a);
        return resultMap;
    }
    
    public static Map<String, Object> generateContact(){
        Account a = (Account)generateAccount().get('result');
        return generateContact(a.Id);
    }

    public static Map<String, Object> generateContact(String accountId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Contact c = new Contact(AccountId = accountId, LastName = 'Contact', FirstName = 'Test', Phone = '1112223333', MobilePhone = '1112223333');
        insert c;

        resultMap.put('result', c);
        resultMap.put('AccountId', accountId);
        return resultMap;
    }
    
    public static Map<String, Object> generateOpportunity(){
        Account a = (Account)generateAccount().get('result');
        return generateOpportunity(a.Id);
    }

    public static Map<String, Object> generateOpportunity(String accountId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Opportunity o = new Opportunity(Name = 'Opportunity Test', AccountId = accountId, StageName = 'New Customer', CloseDate = Date.today());
        insert o;
        
        resultMap.put('result', o);
        resultMap.put('AccountId', accountId);
        return resultMap;
    }

    public static Map<String, Object> generateLead(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Lead l = new Lead(LastName = 'Lead', Company = 'Lead Company', Status = 'Open - Not Contacted', Phone = '1112223333', MobilePhone = '1112223333');
        insert l;

        resultMap.put('result', l);
        return resultMap;
    }

    public static Map<String, Object> generateCampaign(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Campaign c = new Campaign(Name = 'Campaign Test', Status = 'Planned', Type = 'Webinar', StartDate = Date.today(), EndDate = Date.today().addDays(30));
        insert c;

        resultMap.put('result', c);
        return resultMap;
    }

    public static Map<String, Object> generateCase(){
        Account a = (Account)generateAccount().get('result');
        Contact c = (Contact)generateContact(a.Id).get('result');
        return generateCase(a.Id, c.Id);
    }

    public static Map<String, Object> generateCase(String accountId, String contactId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Case c = new Case(Subject = 'Case Test', Status = 'New', Priority = 'Medium', Origin = 'Phone', AccountId = accountId, ContactId = contactId);
        insert c;

        resultMap.put('result', c);
        resultMap.put('AccountId', accountId);
        resultMap.put('ContactId', contactId);
        return resultMap;
    }

    public static Map<String, Object> generateProduct(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Product2 p = new Product2(Name = 'Product Test', IsActive = true);
        insert p;

        resultMap.put('result', p);
        return resultMap;
    }

    public static Map<String, Object> generatePriceBookEntry(String productId){
        map<String,Object> resultMap = new map<String,Object>();
        
        PricebookEntry pbe = new PricebookEntry(Product2Id = productId, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 200, IsActive = true);
        insert pbe;

        resultMap.put('result', pbe);
        resultMap.put('ProductId', productId);
        return resultMap;
    }

    public static Map<String, Object> generateOrder(){
        map<String,Object> resultMap = generateOpportunity();
        Opportunity o = (Opportunity)resultMap.get('result');
        String contactId = (String)resultMap.get('ContactId');
        return generateOrder(o.AccountId, o.Id, contactId);
    }
    
    public static Map<String, Object> generateOrder(String accountId, String opportunityId, String contactId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Order o = new Order(AccountId = accountId, OpportunityId = opportunityId, ShipToContactId = contactId, Pricebook2Id = Test.getStandardPricebookId(), Status = 'Draft', EffectiveDate = Date.today());
        insert o;

        resultMap.put('result', o);
        resultMap.put('AccountId', accountId);
        resultMap.put('OpportunityId', opportunityId);
        return resultMap;
    }

    public static Map<String, Object> generateOrderItem(){
        Order o = (Order)generateOrder().get('result');
        Product2 p = (Product2)generateProduct().get('result');
        PriceBookEntry pbe = (PriceBookEntry)generatePriceBookEntry(p.Id).get('result');
        return generateOrderItem(o.Id, p.Id, pbe.Id);
    }
    
    public static Map<String, Object> generateOrderItem(String orderId, String productId, String priceBookEntryId){
        map<String,Object> resultMap = new map<String,Object>();
        
        OrderItem oi = new OrderItem(OrderId = orderId, Product2Id = productId, PricebookEntryId = priceBookEntryId, UnitPrice = 200, Quantity = 2);
        insert oi;

        resultMap.put('result', oi);
        resultMap.put('OrderId', orderId);
        resultMap.put('ProductId', productId);
        resultMap.put('PricebookEntryId', priceBookEntryId);
        return resultMap;
    }

    public static Map<String, Object> generateQuote(){
        Opportunity o = (Opportunity)generateOpportunity().get('result');
        return generateQuote(o.Id);
    }
    
    public static Map<String, Object> generateQuote(String opportunityId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Quote q = new Quote(Name = 'Quote Test', OpportunityId = opportunityId, Pricebook2Id = Test.getStandardPricebookId(), Status = 'Draft');
        insert q;

        resultMap.put('result', q);
        resultMap.put('OpportunityId', opportunityId);
        return resultMap;
    }

    public static Map<String, Object> generateQuoteLineItem(){
        Quote q = (Quote)generateQuote().get('result');
        Product2 p = (Product2)generateProduct().get('result');
        PriceBookEntry pbe = (PriceBookEntry)generatePriceBookEntry(p.Id).get('result');
        return generateQuoteLineItem(q.Id, p.Id, pbe.Id);
    }
    
    public static Map<String, Object> generateQuoteLineItem(String quoteId, String productId, String priceBookEntryId){
        map<String,Object> resultMap = new map<String,Object>();
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quoteId, Product2Id = productId, PricebookEntryId = priceBookEntryId, UnitPrice = 200, Quantity = 2);
        insert qli;

        resultMap.put('result', qli);
        resultMap.put('QuoteId', quoteId);
        resultMap.put('ProductId', productId);
        resultMap.put('PricebookEntryId', priceBookEntryId);
        return resultMap;
    }

    // *************************************************************
    // * The following methods are for Custom Objects
    // *************************************************************
}
