//
//  SegueProtocol.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/15/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

protocol SegueHandler: class {
  func segueTo(identifier: String)
}
