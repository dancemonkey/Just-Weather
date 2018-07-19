//
//  ZipCodeSelectProtocol.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

protocol ZipCodeHandler {
  func setForecastLocation(for zip: Int)
}
