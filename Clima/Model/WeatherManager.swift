//
//  WeatherManager.swift
//  Clima
//
//  Created by mac on 07/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//Create Interface for WeatherManagerDelegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather : WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    //declare a delegate
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String)  {
        
            let urlString = "\(weatherURL)&appid=\(apiKey!)&q=\(cityName)"
            performRequest(with: urlString)
        
        
    }
    
    
    //This function gets current location (when we tap on the location icon on the top left)
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&appid=\(apiKey!)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        //1. create a URL
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
                //Refactored this line to use closure method without declaring a seperate handle function commented below
                // let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //prints out the data in dataString format
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString!)
                    
                    if let weather = self.parseJson(safeData){
                        //use the delegate to pass data to other classes
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                    
                    //parse to json format
                }
            }
            
            
            
            //4. Start the task
            task.resume()
            
        }
        
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherApiData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //print(weather.getConditionName(weatherId: id))
            
        //refactored
            //print(weather.conditionName)
            //print(weather.temperatureString)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
            
    }
    
    
    
    //Refactor and replaced with the closure way
    
//    func handle(data: Data?, response: URLResponse?, error:Error?) {
//        if error != nil {
//            print(error)
//            return
//        }
//
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//        }
//    }
}
