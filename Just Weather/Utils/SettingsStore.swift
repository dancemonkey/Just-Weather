//
//  SettingsStore.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

class SettingsStore {
  
  enum Keys: String {
    case lastOpen
  }
  
  var defaults: UserDefaults?
  
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
  
}
