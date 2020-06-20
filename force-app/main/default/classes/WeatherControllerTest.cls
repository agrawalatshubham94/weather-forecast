/*
 * Apex test class for class WeatherController.
 */
@isTest
private class WeatherControllerTest {
    
    @isTest static void getWeatherForcastTest() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WeatherBitHttpCalloutMock()); 
        
        String responseBody = WeatherController.getWeatherForcast('city=LONDON,UK&days=1');
        
        Map<String, Object> res = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        
        System.assertEquals('London', res.get('city_name'));
        System.assertEquals('GB', res.get('country_code'));
    }
}