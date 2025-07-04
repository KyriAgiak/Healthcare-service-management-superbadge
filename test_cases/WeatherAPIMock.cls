@isTest
global class WeatherAPIMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);

        // Mocked JSON response similar to what OpenWeatherMap returns
        String body = '{' +
            '"weather": [{' +
                '"description": "clear sky",' +
                '"icon": "01d"' +
            '}],' +
            '"main": {' +
                '"temp": 289.5,' +
                '"feels_like": 287.3,' +
                '"humidity": 70' +
            '}' +
        '}';
        
        res.setBody(body);
        return res;
    }
}