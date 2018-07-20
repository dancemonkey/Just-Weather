//
//  ZipCodeSelectProtocol.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreLocation

protocol ZipCodeHandler {
  func setForecastLocation(for location: CLPlacemark)
  func setForecastForCurrentLocation()
}
