import { LightningElement, api, track } from 'lwc';
import getWeatherForcast from '@salesforce/apexContinuation/WeatherController.getWeatherForcast';

export default class WeatherForcast extends LightningElement {
    data;                                           //to hold forcast data returned from server
    showSpinner = false;                            //to dynamically render spinner/loader
    @track message;                                 //to display success/failure messages for user understanding
    @api forcast_days = 0;                          //indicates how many days forcast to be shown
    @track changeLocation = {                       //wrapper to handle location change button and user input
        'show': false,
        'button_disabled': true,
        'new_location' : ''
    };
    api_home = 'https://www.weatherbit.io/';        //api home/base address.
    weekdays = new Array(                           //array containing weekdays
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    );

    connectedCallback() {                           //method called upon component insertion into DOM
        let self = this;        
        navigator.geolocation.getCurrentPosition(   //if geolocation is available then get forcast
            function(position) {
                self.getForcastData('lat=' + position.coords.latitude + '&lon=' + position.coords.longitude + '&days=' + self.forcast_days);                
            },
            function() {                            //if geolocation not available then ask for user input via changelocation funct.
                self.message = 'Geolocation not available. Please enter a location manually.';
                self.changeLocation.show = true;
            }
        );
    }

    handleChangeLocationOnclick() {                 //handles changeLocation button click to render user input field 
        this.message = null;      
        this.changeLocation.show = true;
        this.changeLocation.button_disabled = true;
    }

    handleCancelOnclick() {                         //handles cancel button click to unrender the change location user input field
        this.changeLocation.show = false;
    }

    handleCityChange(event) {                       //to handle onchange event of user input field
        this.changeLocation.new_location = event.target.value;
        if (event.target.value !== undefined && event.target.value != null && event.target.value !== '') {
            this.changeLocation.button_disabled = false;
        } else {
            this.changeLocation.button_disabled = true;
        }
    }

    handleSetLocationOnclick() {                    //handles set new location button click to get new location weather forcast.
        let loc = this.changeLocation.new_location;
        loc = loc.replace(/[^a-zA-Z0-9, ]/g, "");
        this.getForcastData('city=' + encodeURI(loc.toUpperCase()) + '&days=' + this.forcast_days);
        this.changeLocation.show = false;
    }

    getForcastData(queryString) {                   //calls server method to fetch weather forcast for requested location
        this.showSpinner = true;
        this.data = null;
        this.message = null; 
        
        getWeatherForcast({ q: queryString })
        .then(result => {            
            this.data = JSON.parse(result);
            for(let i=0; i<this.data.data.length; i++) {
                let dt = new Date(this.data.data[i].valid_date);
                this.data.data[i].weather.icon = 'https://www.weatherbit.io/static/img/icons/' + this.data.data[i].weather.icon + '.png';
                this.data.data[i].valid_day = this.weekdays[dt.getDay()];
            }
            this.showSpinner = false;           
        }).catch(() => {
            this.showSpinner = false;
            this.message = 'No weather forecast found!'; 
        });
    }
}