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
    defaults?.set(nil, forKey: Keys.forecastLat.rawValue)
    defaults?.set(nil, forKey: Keys.forecastLong.rawValue)
  }
  
  func saveForecastLocation(as placemark: CLPlacemark) {
    guard let loc = placemark.location else { return }
    defaults?.set(loc.coordinate.latitude, forKey: Keys.forecastLat.rawValue)
    defaults?.set(loc.coordinate.longitude, forKey: Keys.forecastLong.rawValue)
    defaults?.set(placemark.postalCode ?? 00000, forKey: Keys.forecastZIP.rawValue)
    defaults?.set(placemark.locality ?? "No City Defined", forKey: Keys.forecastCity.rawValue)
  }
  
  func saveForecastLocation(as location: CLLocation) {
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
      guard let marks = placemarks else { return }
      self.saveForecastLocation(as: marks[0])
    }
  }
  
  func getSavedForecastCoordinates() -> (lat: Double, long: Double)? {
    guard let locationLat = defaults?.value(forKey: Keys.forecastLat.rawValue) as? Double else { return nil }
    guard let locationLong = defaults?.value(forKey: Keys.forecastLong.rawValue) as? Double else { return nil }
    return (lat: locationLat, long: locationLong)
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
