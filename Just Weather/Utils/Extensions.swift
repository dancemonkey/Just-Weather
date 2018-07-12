//
//  Extensions.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/11/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

extension UIViewController {
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
}
