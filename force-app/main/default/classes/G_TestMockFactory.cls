//============================================
// @description       : A utility class for creating a mock http request.
// @author            : dalton@outlook.com
// @last modified on  : 9/15/2025
// @last modified by  : dalton@outlook.com
// @todo
//    - Potentially added configuration for passing mock body and header as well
//============================================

@isTest
global class G_TestMockFactory implements HttpCalloutMock {

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
