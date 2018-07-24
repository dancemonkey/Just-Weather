//
//  Forecast.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/9/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

struct Forecast: Codable {
  
  // MARK: Properties
  var latitude: Double
  var longitude: Double
  var timezone: String
  
  var currently: CurrentWeather
  var hourly: HourlyWeather
  var daily: DailyWeather
  var alerts: [WeatherAlerts]?
  
  var coordinates: (lat: Double, long: Double) {
    get {
      return (lat: self.latitude, long: self.longitude)
    }
  }
  
  // MARK: Sub-Structs
  struct CurrentWeather: Codable {
    var time: Double
    var summary: String
    var icon: String
    var precipProbability: Double
    var precipType: String?
    var temperature: Double
    var apparentTemperature: Double
    var dewPoint: Double
    var humidity: Double
    var pressure: Double
    var windSpeed: Double
    var cloudCover: Double
  }
  
  struct HourlyWeather: Codable {
    var summary: String
    var icon: String
    var data: [HourlyData]
    
    struct HourlyData: Codable {
      var time: Double
      var summary: String
      var icon: String
      var precipProbability: Double
      var precipType: String?
      var temperature: Double
      var apparentTemperature: Double
      var dewPoint: Double
      var humidity: Double
    }
  }
  
  struct DailyWeather: Codable {
    var summary: String
    var icon: String
    var data: [DailyData]

    struct DailyData: Codable {
      var time: Double
      var summary: String
      var icon: String
      var sunriseTime: Double
      var sunsetTime: Double
      var moonPhase: Double
      var precipProbability: Double
      var precipType: String?
      var temperatureHigh: Double
      var temperatureLow: Double
      var dewPoint: Double
      var humidity: Double
    }

  }
  
  struct WeatherAlerts: Codable {
    var title: String
    var time: Double
    var expires: Double
    var description: String
  }
  
}
