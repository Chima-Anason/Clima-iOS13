//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //autowire the weatherManager object
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Note: this delegate must not be set after the locationManager.requestLocation() else the app will crash.
        locationManager.delegate = self
        
        //Popup to ask the user for permission for their location
        locationManager.requestWhenInUseAuthorization()
        
        //Automatically gets current location when the app start
        locationManager.requestLocation()
        
        //set the class as delegate
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        //this will get current location when the location button on the top left is pressed
        locationManager.requestLocation()
    }
}



//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchedPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true;
        }else{
            textField.placeholder = "Type something";
            return false;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // use searchTextField.text to get the weather for that city.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
}



//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    //call the weatherManager delegate protocol method here to retrieve data from the weatherManager
    //implement didUpdateWeather so it will be notified when the weather is available from the internet
    func didUpdateWeather(_ weatherManager: WeatherManager,weather : WeatherModel) {
         DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate {
    
    //Note From Apple Doc: This two methods/funcs below(didUpdateLocations & didFailWithError) must be called else the app will crash.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            //with this one line of code called it will assist the locationPressed IBAction method to get current location
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

