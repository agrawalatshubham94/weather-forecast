@isTest
global class WeatherBitHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        String jsonBody = 
            '{' + 
                '\"data\": [' +
                    '{' +
                        '\"dewpt\": 11.2,' +
                        '\"snow\": 0,' +
                        '\"uv\": 4.31703,' +
                        '\"weather\": {' +
                            '\"icon\": \"c04d\",' +
                            '\"code\": 804,' +
                            '\"description\": \"Overcast clouds\"' +
                        '},' +
                        '\"wind_dir\": 201,' +
                        '\"clouds_low\": 40' +
                    '}' +
                '],' +
                '\"city_name\": \"London\",' +
                '\"lon\": \"-0.09184\",' +
                '\"timezone\": \"Europe/London\",' +
                '\"lat\": \"51.51279\",' +
                '\"country_code\": \"GB\",' +
                '\"state_code\": \"ENG\"' +
            '}';
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(jsonBody);
        response.setStatusCode(200);
        return response; 
    }
}