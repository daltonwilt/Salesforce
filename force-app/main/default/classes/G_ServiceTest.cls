@isTest
private class G_ServiceTest {
	@isTest
    private static void test_search(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        G_Service.lookup('Account', new List<String>{'Name'}, 'test');
        G_Service.lookup('Account', new List<String>{'Name'}, '');
    }

    @isTest
    private static void test_getPiclistValues(){
        G_Service.getPiclistValues('Account', new List<String>{'Type'});
    }

    @isTest
    private static void test_getRecentlyCreatedRecord(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        G_Service.getRecentlyCreatedRecord(a.Id, new List<String>{'Name'}, 'Account');
    }

    @isTest
    private static void test_getRecords(){
        Map<String,Object> resultMap = G_TestFactory.generateOpportunity();
        Opportunity o = (Opportunity)resultMap.get('result');
        G_Service.getRecords(o.Id, o.AccountId, 'AccountId =: parentId');
    }

    @isTest
    private static void test_getRelatedAllRecords(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        G_Service.getRelatedAllRecords(a.Id);
    }

    @isTest
    private static void test_upsertRecord(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        G_Service.upsertRecord(JSON.deserializeUntyped(JSON.serialize(a)), 'Account');
    }

    @isTest
    private static void test_upsertRecords(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        List<Account> accs = new List<Account>{a};
        G_Service.upsertRecords(JSON.deserializeUntyped(JSON.serialize(accs)), 'Account');
    }
}
