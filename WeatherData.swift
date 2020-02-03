//
//  WeatherData.swift
//  Clima
//
//  Created by Xiaolue Peng on 2020/1/31.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    
    let main : Main
    
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let id : Int
    let description : String
}
