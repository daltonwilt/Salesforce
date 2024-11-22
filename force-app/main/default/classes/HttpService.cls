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
    private static final String ACCOUNT_ID = '63d43193-6ee3-4458-a305-d835be6df736';
    private static final String BASE_URL = 'callout:DSApi';
    // private static final String BASE_URL = 'https://na4.docusign.net';
    private static final String USERNAME = 'jonathan.padilla@parklandusa.com';
    private static final String PASSWORD = 'Parkland2022';

    // private static final String SECRET_KEY = '355150e5-bfb3-4b90-9f03-1e0fe069ccc7';
    private static final String INTEGRATION_KEY = 'ee1e6a3a-5660-4aa6-ba5e-34d1509500cf';
    // private static final String TEMPLATE_ID = '6f15a727-50a5-4fcf-871d-59a2baee716a';

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
