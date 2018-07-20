//
//  LocationManager.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/7/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import CoreLocation

enum ForecastType {
  case current, daily, hourly, alerts, all
  
  func excludes() -> String {
    switch self {
    case .current:
      return "minutely,hourly,daily,alerts,flags"
    case .daily:
      return "minutely,hourly,alerts,current,flags"
    case .hourly:
      return "minutely,daily,alerts,current,flags"
    case .alerts:
      return "minutely,daily,hourly,current,flags"
    case .all:
      return "minutely,flags"
    }
  }
}

class WeatherFetcher {
  
  // functions to fetch weather, different options, based on lat and long or user selected location
  
  let darkSkyURL = "https://api.darksky.net/forecast/"
  let darkSkyKey = "\(DarkSkyKey().value)/"
  
  func getLocation(for location: String?, completion: @escaping ([CLPlacemark]?) -> ()) {
    guard let loc = location else { return }
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(loc) { (placemarks, error) in
      if let marks = placemarks {
        print(marks)
        completion(marks)
      }
    }
  }
  
  func getForecast(_ type: ForecastType, for location: (lat: Double, long: Double), completion: @escaping (Forecast) -> ()) {
    
    guard let url = URL(string: "\(darkSkyURL)\(darkSkyKey)\(location.lat),\(location.long)?exclude=[\(type.excludes())]") else {
      return
    }
    
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
            // need to handle different forecast types: daily, weekly, hourly, alerts only, etc.
            // will break up model to handle different forecast requests
            completion(forecast)
          } catch {
            print(error)
          }
        }
      }
    }
    task.resume()
  }
  
}
