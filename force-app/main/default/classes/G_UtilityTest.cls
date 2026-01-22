@isTest
private class G_UtilityTest {
	@isTest
    private static void test_createSObject(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        G_Utility.createSObject(JSON.deserializeUntyped(JSON.serialize(a)), 'Account');
    }

    @isTest
    private static void test_createSObjects(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        List<Account> accs = new List<Account>{a};
        G_Utility.createSObjects(JSON.deserializeUntyped(JSON.serialize(accs)), 'Account');
    }

    @isTest
    private static void test_getDescribeObjectType(){
        G_Utility.getDescribeObjectType('Account');
    }

    @isTest
    private static void test_getDescribeObjectResult(){
        G_Utility.getDescribeObjectResult('Account');
    }

    @isTest
    private static void test_getDescribeFields(){
        G_Utility.getDescribeFields('Account');
    }

    @isTest
    private static void test_getDirectFieldsById(){
        Map<String,Object> resultMap = G_TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        G_Utility.getDirectFieldsById(a.Id);
    }

    @isTest
    private static void test_getDirectFieldsByType(){
        G_Utility.getDirectFieldsByType('Account');
    }

    @isTest
    private static void test_formatFields(){
        G_Utility.formatFields(G_Utility.getDescribeFields('Account'));
    }
}
