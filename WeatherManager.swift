//
//  WeatherManager.swift
//  Clima
//
//  Created by Xiaolue Peng on 2020/1/31.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather : WeatherModel)
    
    func didFailWithError(_ error : Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ca8747e85911c7600504190aeacf880e&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String) {
        print(cityName)
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: {(data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let responseData = data {
                    if let weatherModel = self.parseJson(weatherData: responseData) {
                        self.delegate?.didUpdateWeather(weatherModel)
                    }
                }
            })
            task.resume()
        }
    }
    
    func parseJson(weatherData : Data) -> WeatherModel?  {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
