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
  @IBOutlet weak var summaryLbl: UILabel!
  @IBOutlet weak var tempHighLbl: UILabel!
  @IBOutlet weak var tempLowLbl: UILabel!
  @IBOutlet weak var alertItem: UIBarButtonItem!
  @IBOutlet weak var locationBtn: UIBarButtonItem!
  
  var locManager: CLLocationManager!
  var fetcher: WeatherFetcher?
  var weatherInfoView: WeatherInfoVC?
  var forecast: Forecast?
  var settings: SettingsStore?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.settings = SettingsStore()
    settings?.saveLastOpen()
    
    fetcher = WeatherFetcher()
    setupLocationManager()
    clearLabels()
    weatherInfoView?.segueDelegate = self
    
    NotificationCenter.default.addObserver(self, selector: #selector(autoRefreshForecast), name: .UIApplicationDidBecomeActive, object: nil)
  }
  
  @objc func clearLabels() {
    tempLabel.text = "--°"
    summaryLbl.text = "--"
    tempHighLbl.text = "--°"
    tempLowLbl.text = "--°"
    hideAlert()
  }
  
  func hideAlert() {
    alertItem.tintColor = .clear
    alertItem.isEnabled = false
  }
  
  func showAlertIndicator() {
    alertItem.tintColor = .red
    alertItem.isEnabled = true
  }
  
  func setupLocationManager() {
    locManager = CLLocationManager()
    locManager.delegate = self
    locManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locManager.startUpdatingLocation()
    }
  }
  
  func updateUIWith(forecast: Forecast) {
    // check for saved location in uerdefaults
    if let loc = settings?.getSavedForecastCity() {
      self.title = loc
    }
    
    // stop updating location in the closure until "refresh" is hit, set forecast property
    self.locManager.stopUpdatingLocation()
    self.forecast = forecast
    
    // populate view objects in the closure
    self.weatherIcon.image = UIImage(named: forecast.currently.icon)
    self.tempLabel.text = "\(Numbers().temperatureFormat(from: forecast.currently.temperature))°"
    self.summaryLbl.text = forecast.currently.summary
    self.weatherInfoView?.setupForecastLabels(with: forecast)
    self.weatherInfoView?.hourlyForecastCollection.reloadData()
    self.tempHighLbl.text = "H: \(Numbers().removeDecimals(from: forecast.daily.data[0].temperatureHigh))°"
    self.tempLowLbl.text = "L: \(Numbers().removeDecimals(from: forecast.daily.data[0].temperatureLow))°"
    
    // alerts
    if let _ = forecast.alerts {
      self.showAlertIndicator()
    }
  }
  
  @objc func autoRefreshForecast() {
    guard let timeSinceOpen = settings?.timeSinceLastOpen() else { return }
    if timeSinceOpen >= 5 {
      self.refreshWeather(sender: self.refreshBtn)
      self.settings?.saveLastOpen()
    }
  }
  
  @IBAction func refreshWeather(sender: UIBarButtonItem) {
    clearLabels()
    locManager.startUpdatingLocation()
  }
  
  @IBAction func alertPressed(sender: UIBarButtonItem) {
    // show alert info screen or something
  }
  
  @IBAction func selectLocation(sender: UIBarButtonItem) {
    self.performSegue(withIdentifier: "showLocationSearch", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showWeatherInfo" {
      weatherInfoView = segue.destination as? WeatherInfoVC
    } else if segue.identifier == "showWeeklyForecast" {
      let destVC = segue.destination as! WeeklyForecastVC
      destVC.dailyForecast = self.forecast?.daily
    } else if segue.identifier == "showLocationSearch" {
      let destVC = segue.destination as! LocationSearchVC
      destVC.zipHandlerDelegate = self
      destVC.fetcher = self.fetcher
    }
  }
}

extension LaunchViewController: SegueHandler {
  func segueTo(identifier: String) {
    self.performSegue(withIdentifier: identifier, sender: self)
  }
}

extension LaunchViewController: ZipCodeHandler {
  func setForecastLocation(for location: CLPlacemark) {
    guard let loc = location.location else { return }
    let forecastLoc: (lat: Double, long: Double) = (loc.coordinate.latitude, loc.coordinate.longitude)
    self.settings?.saveForecastLocation(to: location)
    self.fetcher?.getForecast(.all, for: forecastLoc, completion: { (forecast) in
      self.updateUIWith(forecast: forecast)
    })
  }
  
  func setForecastForCurrentLocation() {
    settings?.clearForecastLocation()
    self.locManager.startUpdatingLocation()
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
    
    if let fetcher = self.fetcher {
      if let coord = settings?.getSavedForecastCoordinates() {
        fetcher.getForecast(.all, for: coord, completion: { (forecast) in
          print("getting from settings")
          self.updateUIWith(forecast: forecast)
        })
      } else {
        fetcher.getForecast(.all, for: (lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)) { forecast in
          print("getting fresh forecast")
          self.updateUIWith(forecast: forecast)
          self.settings?.saveForecastLocation(to: userLocation)
        }
      }
    }
  }
}

