//
//  LocationManager.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/7/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

class WeatherFetcher {
  
  // functions to fetch weather, different options, based on lat and long or user selected location
  
  let darkSkyURL = "https://api.darksky.net/forecast/"
  let darkSkyKey = "e8cce189cf2466d799e75779bdf4fc37/"
  let exclude = "minutely"
  
  func getWeeklyForecast(for location: (lat: Double, long: Double), completion: @escaping (String, String) -> ()) {
    
    guard let url = URL(string: "\(darkSkyURL)\(darkSkyKey)\(location.lat),\(location.long)?exclude=[\(exclude)]") else {
      return
    }
    
    // pull this out into its own function with options for what type of forecast you are fetching
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
      DispatchQueue.main.async {
        if let error = responseError {
          print(error.localizedDescription)
        } else if let jsonData = responseData {
          do {
            let forecast = try JSONDecoder().decode(Forecast.self, from: jsonData)
            completion(forecast.currently.icon, self.temperatureFormat(from: forecast.currently.temperature))
          } catch {
            print(error)
          }
        }
      }
    }
    task.resume()
  }
  
  func temperatureFormat(from temperature: Double) -> String {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale.current
    
    return formatter.string(from: NSNumber(value: temperature))!
  }
  
}
