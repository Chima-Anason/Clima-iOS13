//
//  WeatherData.swift
//  Clima
//
//  Created by mac on 08/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherApiData : Codable {
    let name :String
    let main : Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp : Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
