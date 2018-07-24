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
  var store: SettingsStore?
  var forecastLocation: ForecastLocation?
  var currentLocation: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.store = SettingsStore()
    store?.saveLastOpen()
    
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
    
    // stop updating location in the closure until "refresh" is hit, set forecast property
    self.locManager.stopUpdatingLocation()
    self.clearLabels()
    self.forecast = forecast
    self.title = forecastLocation!.locality
 
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
    guard let timeSinceOpen = store?.timeSinceLastOpen() else { return }
    if timeSinceOpen >= 5 {
      self.refreshWeather(sender: self.refreshBtn)
      self.store?.saveLastOpen()
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
    self.performSegue(withIdentifier: "showLocationSelect", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showWeatherInfo" {
      weatherInfoView = segue.destination as? WeatherInfoVC
    } else if segue.identifier == "showWeeklyForecast" {
      let destVC = segue.destination as! WeeklyForecastVC
      destVC.dailyForecast = self.forecast?.daily
    } else if segue.identifier == "showLocationSelect" {
      let destVC = segue.destination as! LocationSelectVC
      destVC.forecastLocationDelegate = self
      destVC.fetcher = self.fetcher
      destVC.store = self.store
    }
  }
}

extension LaunchViewController: SegueHandler {
  func segueTo(identifier: String) {
    self.performSegue(withIdentifier: identifier, sender: self)
  }
}

extension LaunchViewController: ForecastLocationSetProtocol {
  func setForecastLocation(for location: CLPlacemark) {
    guard let loc = location.location else { return }
    currentLocation = false
    self.forecastLocation = ForecastLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, postalCode: location.postalCode, locality: location.locality)
    self.fetcher?.getForecast(.all, for: (forecastLocation!.latitude, forecastLocation!.longitude), completion: { (forecast) in
      self.updateUIWith(forecast: forecast)
    })
  }
  
  func setForecastForCurrentLocation() {
    currentLocation = true
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
      if currentLocation {
        fetcher.getForecast(.all, for: (userLocation.coordinate.latitude, userLocation.coordinate.longitude)) { (forecast) in
          let geoCoder = CLGeocoder()
          geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
            if let marks = placemarks {
              self.forecastLocation = ForecastLocation(latitude: marks[0].location!.coordinate.latitude, longitude: marks[0].location!.coordinate.longitude, postalCode: marks[0].postalCode, locality: marks[0].locality)
              self.updateUIWith(forecast: forecast)
            }
          })
        }
      } else {
        fetcher.getForecast(.all, for: (forecastLocation!.latitude, forecastLocation!.longitude)) { (forecast) in
          self.updateUIWith(forecast: forecast)
        }
      }
    }
  }
}

