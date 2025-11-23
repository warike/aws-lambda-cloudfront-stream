function handler(event) {
    var request = event.request;
    var host = request.headers.host.value;
    var allowedDomain = 'dev.zaistev.com';

    if (host !== allowedDomain) {
        return {
            statusCode: 403,
            statusDescription: 'Forbidden',
            headers: {
                "content-type": { "value": "text/plain" }
            },
            body: { "encoding": "text", "value": "Access denied. Please use the custom domain." }
        };
    }
    return request;
}
