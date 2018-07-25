//
//  Extensions.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/11/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class Numbers {
  func temperatureFormat(from temperature: Double) -> String {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale.current
    
    return formatter.string(from: NSNumber(value: temperature))!
  }
  
  func removeDecimals(from double: Double) -> String {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale.current
    
    return formatter.string(from: NSNumber(value: double))!
  }
  
  func getHour(from time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    let formatter = DateFormatter()
    formatter.dateFormat = "h a"
    return formatter.string(from: date)
  }
  
  func getTimeAndDate(from time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy HH:mm"
    return formatter.string(from: date)
  }
}
