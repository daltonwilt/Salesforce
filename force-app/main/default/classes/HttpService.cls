/**
 * @description       :
 * @author            : dalton@bluecitystudios.com
 * @group             :
 * @last modified on  : 10/3/2024
 * @last modified by  : dalton@bluecitystudios.com
 **/
public class HttpService {
    public class CustomException extends Exception {}

    // DocuSign Integration Credentials
    private static final String ACCOUNT_ID = 'docusign_accountid';
    private static final String BASE_URL = 'callout:named_credential';
    // private static final String BASE_URL = 'https://na4.docusign.net';
    private static final String USERNAME = 'example@mail.com;
    private static final String PASSWORD = 'password12';

    // private static final String SECRET_KEY = 'docusign_secret_key';
    private static final String INTEGRATION_KEY = 'docusign_integration_key';
    // private static final String TEMPLATE_ID = 'template_id';

    // TODO:
    // - Add Wrapper for Header values

    public static HttpResponse runRequest(Map<String, String> auth, String endpoint, String payload, String method, String type) {
        // Create an instance of HttpRequest
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');

        // Set the Authorization header with username and password using Basic authentication
        // Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
        // String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        Blob headerValue = Blob.valueOf(INTEGRATION_KEY);
        String authorizationHeader = 'Bearer ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        if(payload != '')
            req.setBody(payload);

        // Create an instance of Http
        Http http = new Http();
        HttpResponse res;
        try {
            //  Send the request
            res = http.send(req);

            // Create HttpRequest_Log
            // log(method, endpoint, req.getBody(), res.getBody(), res.getStatusCode(), res.getStatus());
            return res;
        } catch (Exception e) {
            throw new CustomException('Message :' +e.getMessage()+ ' :: Trace :' +e.getStackTraceString());
        }
    }

    public static String stringResponse(Map<String, String> auth, String endpoint, String payload, String method, String type) {
        HttpResponse res = runRequest(auth, endpoint, payload, method, type);
        return res.getBody();
    }

    public static Blob blobResponse(Map<String, String> auth, String endpoint, String payload, String method, String type) {
        HttpResponse res = runRequest(auth, endpoint, payload, method, type);
        return res.getBodyAsBlob();
    }

    

    // @future(callout=true)
    // public static void log(String method, String endpoint, String requestPayload, String responsePayload, Integer statusCode, String status) {
    //     System.enqueueJob(new HttpLogQueueable(method, endpoint, requestPayload, responsePayload, statusCode, status));
    // }
}

// 200	OK	The request was processed and returned successfully. Nothing was changed.
// 201	Created	The new resource was created successfully
// 400	Bad Request	Problem with the request, such as a missing, invalid or type mismatched parameter
// 401	Unauthorized	The request did not have valid authorization credentials
// 403	Forbidden	Private data you are not allowed to access, or you’ve hit a rate limit.
// 404	Not Found	Your URL is wrong, or the requested resource doesn’t exist
// 500	Server Error	We call this the “crap code” error. Basically we’ve got a problem on our side. If this persists, please contact support. We log and review all errors but your help often helps us fix it quicker.
// 503	Service Unavailable	Our API is down. Please try again. We work hard to make this rare.
