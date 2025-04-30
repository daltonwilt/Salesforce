@isTest
private class GenericUtilityTest {
	@isTest
    private static void test_createSObject(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        GenericUtility.createSObject(JSON.deserializeUntyped(JSON.serialize(a)), 'Account');
    }

    @isTest
    private static void test_createSObjects(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        List<Account> accs = new List<Account>{a};
        GenericUtility.createSObjects(JSON.deserializeUntyped(JSON.serialize(accs)), 'Account');
    }

    @isTest
    private static void test_getDescribeObjectType(){
        GenericUtility.getDescribeObjectType('Account');
    }

    @isTest
    private static void test_getDescribeObjectResult(){
        GenericUtility.getDescribeObjectResult('Account');
    }

    @isTest
    private static void test_getDescribeFields(){
        GenericUtility.getDescribeFields('Account');
    }

    @isTest
    private static void test_getDirectFieldsById(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        GenericUtility.getDirectFieldsById(a.Id);
    }

    @isTest
    private static void test_getDirectFieldsByType(){
        GenericUtility.getDirectFieldsByType('Account');
    }

    @isTest
    private static void test_formatFields(){
        GenericUtility.formatFields(GenericUtility.getDescribeFields('Account'));
    }
}
