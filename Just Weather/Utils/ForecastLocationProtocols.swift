//
//  ZipCodeSelectProtocol.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreLocation

protocol ForecastLocationSetProtocol: class {
  func setForecastLocation(for location: CLPlacemark)
  func setForecastForCurrentLocation()
}

protocol LocationStorageUpdateProtocol: class {
  func updateLocations()
}
