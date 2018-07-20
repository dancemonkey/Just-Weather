//
//  SettingsStore.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import CoreLocation

class SettingsStore {
  
  private enum Keys: String {
    case lastOpen, forecastLat, forecastLong, forecastCity, forecastZIP
  }
  
  private var defaults: UserDefaults?
  
  init() {
    self.defaults = UserDefaults()
  }
  
  func saveLastOpen() {
    defaults?.set(Date().timeIntervalSince1970, forKey: Keys.lastOpen.rawValue)
  }
  
  func timeSinceLastOpen() -> Int? {
    guard let lastOpen = defaults?.double(forKey: Keys.lastOpen.rawValue) else {
      return nil
    }
    let lastOpenDate = Date(timeIntervalSince1970: lastOpen)
    let timeSinceLastOpen = Date().timeIntervalSince(lastOpenDate)    
    
    return Int(timeSinceLastOpen/60)
  }
  
  func clearForecastLocation() {
    defaults?.removeObject(forKey: Keys.forecastCity.rawValue)
    defaults?.removeObject(forKey: Keys.forecastZIP.rawValue)
    defaults?.removeObject(forKey: Keys.forecastLat.rawValue)
    defaults?.removeObject(forKey: Keys.forecastLong.rawValue)
  }
  
  func saveForecastLocation(to location: CLPlacemark) {
    guard let loc = location.location else { return }
    defaults?.set(loc.coordinate.latitude, forKey: Keys.forecastLat.rawValue)
    defaults?.set(loc.coordinate.longitude, forKey: Keys.forecastLong.rawValue)
    defaults?.set(location.postalCode ?? 00000, forKey: Keys.forecastZIP.rawValue)
    defaults?.set(location.locality ?? "No City Defined", forKey: Keys.forecastCity.rawValue)
  }
  
  func getSavedForecastCoordinates() -> (Double, Double)? {
    guard let locationLat = defaults?.double(forKey: Keys.forecastLat.rawValue) else { return nil }
    guard let locationLong = defaults?.double(forKey: Keys.forecastLong.rawValue) else { return nil }
    return (locationLat, locationLong)
  }
  
  func getSavedForecastCity() -> String? {
    guard let city = defaults?.string(forKey: Keys.forecastCity.rawValue) else { return nil }
    return city
  }
  
  func getSavedForecastZip() -> Int? {
    guard let zip = defaults?.integer(forKey: Keys.forecastZIP.rawValue) else { return nil }
    return zip
  }
  
}
