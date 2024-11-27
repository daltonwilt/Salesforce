/**
 * @description       : Utilized for initializing mock data in regards to HTTP Requests
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
@isTest
global class TestMockFactory implements HttpCalloutMock {

    public Integer status_code {get; set;}

    public TestMockFactory(Integer code) {
        status_code = code;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(TestFactory.mockResponse);
        res.setStatusCode(status_code);
        return res;
    }

}
