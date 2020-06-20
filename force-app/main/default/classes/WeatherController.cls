/*
 * Apex wrapper for the WeatherBit REST API.
 * API documentation is available here: https://www.weatherbit.io/api/weather-forecast-16-day
 */
public with sharing class WeatherController {

    private static sObject weatherBitConfig;
    private final static String METHOD = 'GET';
    
    static {
        weatherBitConfig = Utility.getMetadata('WeatherBit__mdt').get('Daily Forcasts');
    }
    
    /*****************************************************************************************************************************
     * Method Name : getWeatherForcast
     * Parameters : q - API query parameter.
     * Return type : String - Response JSON string.
     */
    @AuraEnabled(continuation=true cacheable=true)
    public static String getWeatherForcast(String q) {
        String url = 
            String.valueOf(weatherBitConfig.get('Base_URL__c')) + 
            String.valueOf(weatherBitConfig.get('Endpoint__c')) +
            '?' + q + 
            '&key=' + String.valueOf(weatherBitConfig.get('API_Key__c'));
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();        
        req.setMethod(METHOD);    
        req.setEndpoint(url);
		try {
            HTTPResponse res = http.send(req);
			return res.getBody();        	
        } catch(Exception ex){
            return '{"error": "' + ex.getMessage() + '"}';
        }        
    }
}