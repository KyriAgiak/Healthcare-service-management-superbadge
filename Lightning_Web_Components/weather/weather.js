import { LightningElement } from 'lwc';
import { api, wire } from 'lwc';
import getWeatherDetails from '@salesforce/apex/WeatherAPIHandler.getWeatherDetails';

export default class Weather extends LightningElement {
    @api recordId;
    info = [];
    error;



    @wire(getWeatherDetails, { recordId: '$recordId' })
    wiredInfo({ error, data }) {
    if (data) {
        this.info = data;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.info = [];
    }
}
    
    get location(){
       if(this.info[0] !=null){
            return this.info[0];
        }else{
            return 'No weather information found for that customer location';
        }
    }

    get description(){

        return this.info[1];
    }

    get url(){
        return this.info[2];
    }

    get temp(){
        let celsius = this.info[3] - 273.15;
        return Math.round(celsius);
    }

    get feels_like(){
       let celsius = this.info[4] - 273.15;
        return Math.round(celsius);
    }

    get humidity(){
        let humidity = this.info[5];
        if (humidity < 30) {
            return "Low";
        } else if (humidity <= 60) {
            return "Medium";
        } else {
            return "High";
        }   
    }

    get errorMessage() {
        if (this.error) {
            return this.error.body ? this.error.body.message : this.error.message;
        }
        return '';
    }
        

   get cardtitle() {
    return `Weather in ${this.location}`;
    }
}