/**
 * A utility class for making HTTP requests, specifically designed for DocuSign integration.
 * 
 * @author            : dalton@bluecitystudios.com
 * @last modified on  : 9/15/2025
 * @last modified by  : dalton@bluecitystudios.com
 * @todo
 *   - Implement logging of HTTP requests and responses.
 */
public class HttpService {

    public static HttpResponse request(Map<String, String> auth, String endpoint, String method, String payload) {
        // Create an instance of HttpRequest
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        for(String key : auth.keySet())
            req.setHeader(key, auth.get(key));

        if(payload != '') req.setBody(payload);

        // Create an instance of Http
        Http http = new Http();
        HttpResponse res;
        try {
            //  Send the request
            res = http.send(req);

            // Create HttpLog
            // log(method, endpoint, req.getBody(), res.getBody(), res.getStatusCode(), res.getStatus());
            return res;
        } catch (Exception e) {
            System.debug('Message :' +e.getMessage()+ ' :: Trace :' +e.getStackTraceString());
            return null;
        }
    }

    // @future(callout=true)
    // public static void log(String method, String endpoint, String requestPayload, String responsePayload, Integer statusCode, String status) {
    //     Http_Log__c log = new Http_Log__c();
    //     log.Method__c = method;
    //     log.Endpoint__c = endpoint;
    //     log.Request_Payload__c = requestPayload;
    //     log.Response_Payload__c = responsePayload;
    //     log.Requested_By__c = UserInfo.getUserId();
    //     log.Request_Date__c = DateTime.now();
    //     log.Status_Code__c = statusCode;
    //     log.Status__c = status;
    //     insert log;
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
