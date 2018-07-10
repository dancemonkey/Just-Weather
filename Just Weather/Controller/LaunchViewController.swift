//
//  ViewController.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/7/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreLocation

class LaunchViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var refreshBtn: UIBarButtonItem!
  
  var locManager: CLLocationManager!
  var fetcher: WeatherFetcher?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetcher = WeatherFetcher()
    setupLocationManager()
    tempLabel.text = ""
  }
  
  func setupLocationManager() {
    locManager = CLLocationManager()
    locManager.delegate = self
    locManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locManager.startUpdatingLocation()
    }
  }
  
  @IBAction func refreshWeather(sender: UIBarButtonItem) {
    locManager.startUpdatingLocation()
  }
  
}

extension LaunchViewController {
  
  // MARK: CLLocationManager
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locManager.startUpdatingLocation()
    } else if status == .denied {
      // ask for their location manually before doing weather stuff
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation: CLLocation = locations[0] as CLLocation
    
    // do weather stuff with lat and long
    if let fetcher = self.fetcher {
      fetcher.getWeeklyForecast(for: (lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)) {iconName, temp in
        
        // stop updating location in the closure, until "refresh" is hit
        self.locManager.stopUpdatingLocation()
        
        // populate view objects in the closure
        self.weatherIcon.image = UIImage(named: iconName)
        self.tempLabel.text = "\(temp)°"
        
      }
    }
  }
}

