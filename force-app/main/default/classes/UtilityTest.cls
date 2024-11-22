/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
@isTest
private class UtilityTest {
	@isTest
    private static void test_createSObject(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        Utility.createSObject(JSON.deserializeUntyped(JSON.serialize(a)), 'Account');
    }

    @isTest
    private static void test_createSObjects(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        List<Account> accs = new List<Account>{a};
        Utility.createSObjects(JSON.deserializeUntyped(JSON.serialize(accs)), 'Account');
    }

    @isTest
    private static void test_getDescribeObjectType(){
        Utility.getDescribeObjectType('Account');
    }

    @isTest
    private static void test_getDescribeObjectResult(){
        Utility.getDescribeObjectResult('Account');
    }

    @isTest
    private static void test_getDescribeFields(){
        Utility.getDescribeFields('Account');
    }

    @isTest
    private static void test_getDirectFieldsById(){
        Map<String,Object> resultMap = TestFactory.generateAccount();
        Account a = (Account)resultMap.get('result');
        Utility.getDirectFieldsById(a.Id);
    }

    @isTest
    private static void test_getDirectFieldsByType(){
        Utility.getDirectFieldsByType('Account');
    }

    @isTest
    private static void test_formatFields(){
        Utility.formatFields(Utility.getDescribeFields('Account'));
    }
}
