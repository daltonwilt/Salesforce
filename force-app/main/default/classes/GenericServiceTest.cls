@isTest
private class GenericServiceTest {
	@isTest
    private static void test_search(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        GenericService.lookup('Account', new List<String>{'Name'}, 'test');
        GenericService.lookup('Account', new List<String>{'Name'}, '');
    }

    @isTest
    private static void test_getPiclistValues(){
        GenericService.getPiclistValues('Account', new List<String>{'Type'});
    }

    @isTest
    private static void test_getRecentlyCreatedRecord(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        GenericService.getRecentlyCreatedRecord(a.Id, new List<String>{'Name'}, 'Account');
    }

    @isTest
    private static void test_getRecords(){
        Map<String,Object> resultMap = TestFactory.generateOpportunity();
        Opportunity o = (Opportunity)resultMap.get('result');
        GenericService.getRecords(o.Id, o.AccountId, 'AccountId =: parentId');
    }

    @isTest
    private static void test_getRelatedAllRecords(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        GenericService.getRelatedAllRecords(a.Id);
    }

    @isTest
    private static void test_upsertRecord(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        GenericService.upsertRecord(JSON.deserializeUntyped(JSON.serialize(a)), 'Account');
    }

    @isTest
    private static void test_upsertRecords(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        List<Account> accs = new List<Account>{a};
        GenericService.upsertRecords(JSON.deserializeUntyped(JSON.serialize(accs)), 'Account');
    }
}
