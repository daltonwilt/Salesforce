@isTest
public class HttpServiceTest {

    @isTest
    static void testRequestSuccess() {
        // Set mock response
        Test.setMock(HttpCalloutMock.class, new TestMockFactory(200));

        // Prepare test data
        Map<String, String> auth = new Map<String, String>{
            'Authorization' => 'Bearer testtoken',
            'Content-Type' => 'application/json'
        };
        String endpoint = 'https://www.google.com/';
        String method = 'GET';
        String payload = '{"data":"value"}';

        // Perform test
        Test.startTest();
        HttpResponse res = HttpService.request(auth, endpoint, method, payload);
        Test.stopTest();
    }

    @isTest
    static void testRequestException() {
        // Set mock response that throws error
        Test.setMock(HttpCalloutMock.class, new TestMockFactory(500));


        Map<String, String> auth = new Map<String, String>{
            'Authorization' => 'Bearer testtoken'
        };
        String endpoint = 'https://www.google.com/';
        String method = 'GET';
        String payload = '';

        Test.startTest();
        HttpService.request(auth, endpoint, method, payload);
        Test.stopTest();
    }
}