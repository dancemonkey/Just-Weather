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
  
  func getWeeklyForecast(for location: (lat: Double, long: Double), completion: @escaping (String) -> ()) {
    
    guard let url = URL(string: "\(darkSkyURL)\(darkSkyKey)\(location.lat),\(location.long)") else {
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
          // decode jsonData to a forecast struct that I have yet to create
          do {
            let forecast = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: AnyObject]
            
            // initialize forecast model object from the forecast JSON serialization            
            if let currently = forecast["currently"] as? [String: AnyObject] {
              let iconName = currently["icon"] as! String
              completion(iconName)
            }
            
          } catch let error as NSError {
            print(error.localizedDescription)
          }
        }
      }
    }
    task.resume()
  }
  
}
