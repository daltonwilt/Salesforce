/**
 * @description       : Test Factory is used for all Test classes for initializing data
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
@isTest
global class TestFactory {

    public static String mockResponse = '{"envelopeId":"123456789","envelopeDocuments":[{"documentId":"1","documentIdGuid":"8d2c1624-5767-4df7-9155-63cb161d1e40","name":"Tropic Equip Loan Agreement.pdf","type":"content","uri":"/envelopes/695d22e9-42bc-455d-82da-5e056a1ca1c4/documents/1","order":"1","pages":[{"pageId":"97df143a-0a5d-4806-ab1f-c71240436fee","sequence":"1","height":"792","width":"612","dpi":"72"},{"pageId":"d74b19b7-558c-46bd-9c1c-e9d72ee73bc0","sequence":"2","height":"792","width":"612","dpi":"72"},{"pageId":"799ae54a-fea2-4acf-82cd-19d891d32ac7","sequence":"3","height":"792","width":"612","dpi":"72"},{"pageId":"5ddcbb97-1c1b-4eb9-9c68-6da32a8216c8","sequence":"4","height":"792","width":"612","dpi":"72"},{"pageId":"e1f71fc5-df21-4b7b-b0b0-d4ce72c282f7","sequence":"5","height":"792","width":"612","dpi":"72"},{"pageId":"ae24d616-eb33-44a8-b437-539f32772fa6","sequence":"6","height":"792","width":"612","dpi":"72"},{"pageId":"3e36b64f-15c9-41f9-b974-dd2d737a1d03","sequence":"7","height":"792","width":"612","dpi":"72"},{"pageId":"bba28437-76eb-403e-9ba7-3128d10fb7fc","sequence":"8","height":"792","width":"612","dpi":"72"},{"pageId":"5f1efd5e-47c0-41a8-b295-11295fa2dbbd","sequence":"9","height":"792","width":"612","dpi":"72"}],"availableDocumentTypes":[{"type":"electronic","isDefault":"true"}],"display":"inline","includeInDownload":"true","signerMustAcknowledge":"no_interaction","templateRequired":"false","authoritativeCopy":"false"},{"documentId":"certificate","documentIdGuid":"73b17bbf-888d-42e8-a873-c7416551bc5a","name":"Summary","type":"summary","uri":"/envelopes/695d22e9-42bc-455d-82da-5e056a1ca1c4/documents/certificate","order":"999","availableDocumentTypes":[{"type":"electronic","isDefault":"true"}],"display":"inline","includeInDownload":"true","signerMustAcknowledge":"no_interaction","templateRequired":"false","authoritativeCopy":"false"}]}';
    public static Integer mockStatusCode = 200;

    public static map<String, Object> generateAccount(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Account a = new Account(Name = 'Account Test');
        insert a;

        resultMap.put('result', a);
        return resultMap;
    }
    
    public static map<String, Object> generateContact(){
        Account a = (Account)generateAccount().get('result');
        return generateContact(a.Id);
    }

    public static map<String, Object> generateContact(String accountId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Contact c = new Contact(AccountId = accountId, LastName = 'Contact', FirstName = 'Test', Phone = '1112223333', MobilePhone = '1112223333');
        insert c;

        resultMap.put('result', c);
        resultMap.put('AccountId', accountId);
        return resultMap;
    }
    
    public static map<String, Object> generateOpportunity(){
        map<String,Object> resultMap = generateContact();
        String accoundId = (String)resultMap.get('AccountId');
        Contact c = (Contact)resultMap.get('result');
        return generateOpportunity(accoundId, c.Id);
    }

    public static map<String, Object> generateOpportunity(String accountId, String contactId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Opportunity q = new Opportunity(Name = 'Opportunity Test', AccountId = accountId, StageName = 'New Customer', CloseDate = Date.today());
        insert q;
        
        resultMap.put('result', q);
        resultMap.put('AccountId', accountId);
        resultMap.put('ContactId', contactId);
        return resultMap;
    }

    public static map<String, Object> generatePrice(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Price__c p = new Price__c(Name = 'Price Test', Type__c = 'Tankwagon');
        insert p;

        resultMap.put('result', p);
        return resultMap;
    }

    public static map<String, Object> generatePriceEntry(){
        Account a = (Account)generateAccount().get('result');
        Opportunity o = (Opportunity)generateOpportunity().get('result');
        Price__c p = (Price__c)generatePrice().get('result');
        return generatePriceEntry(a.Id, o.Id, p.Id);
    }

    public static map<String, Object> generatePriceEntry(String accountId, String opportunityId, String priceId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Price_Entry__c p = new Price_Entry__c(Qualified_Lead__c = accountId, Opportunity__c = opportunityId, Price__c = priceId);
        insert p;
        
        resultMap.put('result', p);
        resultMap.put('AccountId', accountId);
        resultMap.put('OpportunityId', opportunityId);
        resultMap.put('PriceId', priceId);
        return resultMap;
    }

    public static map<String, Object> generateProductLine(){
        Opportunity o = (Opportunity)generateOpportunity().get('result');
        return generateProductLine(o.Id);
    }
    
    public static map<String, Object> generateProductLine(String opportunityId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Product_Line__c pl = new Product_Line__c(Name = 'Product Line Test', Opportunity__c = opportunityId);
        insert pl;

        resultMap.put('result', pl);
        resultMap.put('OpportunityId', opportunityId);
        return resultMap;
    }

    public static map<String, Object> generateProduct(){
        map<String,Object> resultMap = new map<String,Object>();
        
        Product2 p = new Product2(Name = 'Product Test', Family = 'Mobil', IsActive = true);
        insert p;

        resultMap.put('result', p);
        return resultMap;
    }

    public static map<String, Object> generatePriceBookEntry(String productId){
        map<String,Object> resultMap = new map<String,Object>();
        
        PricebookEntry pbe = new PricebookEntry(Product2Id = productId, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 200, IsActive = true);
        insert pbe;

        resultMap.put('result', pbe);
        resultMap.put('ProductId', productId);
        return resultMap;
    }

    public static map<String, Object> generateOrder(){
        map<String,Object> resultMap = generateOpportunity();
        Opportunity o = (Opportunity)resultMap.get('result');
        String contactId = (String)resultMap.get('ContactId');
        return generateOrder(o.AccountId, o.Id, contactId);
    }
    
    public static map<String, Object> generateOrder(String accountId, String opportunityId, String contactId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Order o = new Order(AccountId = accountId, OpportunityId = opportunityId, ShipToContactId = contactId, Pricebook2Id = Test.getStandardPricebookId(), Status = 'Draft', EffectiveDate = Date.today(), Delivery_Window__c = 'undefined');
        insert o;

        resultMap.put('result', o);
        resultMap.put('AccountId', accountId);
        resultMap.put('OpportunityId', opportunityId);
        return resultMap;
    }

    public static map<String, Object> generateOrderItem(){
        Order o = (Order)generateOrder().get('result');
        Product2 p = (Product2)generateProduct().get('result');
        PriceBookEntry pbe = (PriceBookEntry)generatePriceBookEntry(p.Id).get('result');
        return generateOrderItem(o.Id, p.Id, pbe.Id);
    }
    
    public static map<String, Object> generateOrderItem(String orderId, String productId, String priceBookEntryId){
        map<String,Object> resultMap = new map<String,Object>();
        
        OrderItem oi = new OrderItem(OrderId = orderId, Product2Id = productId, PricebookEntryId = priceBookEntryId, UnitPrice = 200, Quantity = 2);
        insert oi;

        resultMap.put('result', oi);
        resultMap.put('OrderId', orderId);
        resultMap.put('ProductId', productId);
        resultMap.put('PricebookEntryId', priceBookEntryId);
        return resultMap;
    }


    public static map<String, Object> generateQuote(){
        Opportunity o = (Opportunity)generateOpportunity().get('result');
        return generateQuote(o.Id);
    }
    
    public static map<String, Object> generateQuote(String opportunityId){
        map<String,Object> resultMap = new map<String,Object>();
        
        Quote q = new Quote(Name = 'Quote Test', OpportunityId = opportunityId, Pricebook2Id = Test.getStandardPricebookId(), Status = 'Draft');
        insert q;

        resultMap.put('result', q);
        resultMap.put('OpportunityId', opportunityId);
        return resultMap;
    }

    public static map<String, Object> generateQuoteLineItem(){
        Quote q = (Quote)generateQuote().get('result');
        Product2 p = (Product2)generateProduct().get('result');
        PriceBookEntry pbe = (PriceBookEntry)generatePriceBookEntry(p.Id).get('result');
        return generateQuoteLineItem(q.Id, p.Id, pbe.Id);
    }
    
    public static map<String, Object> generateQuoteLineItem(String quoteId, String productId, String priceBookEntryId){
        map<String,Object> resultMap = new map<String,Object>();
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = quoteId, Product2Id = productId, PricebookEntryId = priceBookEntryId, UnitPrice = 200, Quantity = 2);
        insert qli;

        resultMap.put('result', qli);
        resultMap.put('QuoteId', quoteId);
        resultMap.put('ProductId', productId);
        resultMap.put('PricebookEntryId', priceBookEntryId);
        return resultMap;
    }
}
