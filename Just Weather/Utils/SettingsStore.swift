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
    case lastOpen, forecastLat, forecastLong, forecastCity, forecastZIP, locations
  }
  
  private var defaults: UserDefaults?
  private var locations: [Data]?
  
  init() {
    self.defaults = UserDefaults()
    self.locations = [Data]()
    if let savedLocs = defaults?.array(forKey: Keys.locations.rawValue) {
      for loc in savedLocs {
        self.locations?.append(loc as! Data)
      }
    }
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
  
  func saveForecastLocation(as placemark: CLPlacemark) {
    if self.locations == nil {
      self.locations = [Data]()
    }
    let locData = NSKeyedArchiver.archivedData(withRootObject: placemark)
    locations!.append(locData)
    defaults?.set(self.locations, forKey: Keys.locations.rawValue)
  }
  
  func saveForecastLocation(as location: CLLocation) {
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
      guard let marks = placemarks else { return }
      self.saveForecastLocation(as: marks[0])
    }
  }
  
  func getSavedForecasts() -> [CLPlacemark]? {
    guard let locs = self.locations else {
      return nil
    }
    var forecastLocations = [CLPlacemark]()
    for loc in locs {
      forecastLocations.append(NSKeyedUnarchiver.unarchiveObject(with: loc) as! CLPlacemark)
    }
    return forecastLocations
  }
  
  func deleteForecastLocation(at index: Int) {
    print("deleting this homey: \(locations?[index])")
    print("removing object in store at location: \(index)")
    print(self.locations?.count)
    self.locations?.remove(at: index)
    print(self.locations?.count)
    print("saving freshly trimmed array to defaults")
    self.defaults?.set(self.locations, forKey: Keys.locations.rawValue)
  }
  
}
