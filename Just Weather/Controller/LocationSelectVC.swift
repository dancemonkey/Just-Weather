//
//  LocationSelectVC.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/21/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSelectVC: UIViewController, LocationStorageUpdateProtocol {
  
  weak var forecastLocationDelegate: ForecastLocationSetProtocol?
  var fetcher: WeatherFetcher?
  var store: SettingsStore?
  @IBOutlet weak var tableView: UITableView!
  
  // get from settings or core data and populate table
  var forecastLocations: [CLPlacemark]?

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    updateLocations()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func updateLocations() {
    if let locations = store!.getSavedForecasts() {
      self.forecastLocations = locations
    } else {
      self.forecastLocations = [CLPlacemark]()
    }
    self.tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showLocationSearch" {
      let destVC = segue.destination as! LocationSearchVC
      destVC.fetcher = self.fetcher
      destVC.storageUpdateDelegate = self
      destVC.store = self.store
    }
  }
  
  @IBAction func searchTapped(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "showLocationSearch", sender: self)
  }
}

extension LocationSelectVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let locations = forecastLocations else {
      print("one row")
      return 1
    }
    print("number of rows = \(locations.count + 1)")
    return locations.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
    if indexPath.row == 0 {
      cell.textLabel?.text = "Current Location"
      cell.imageView?.image = UIImage(named: "pin")
      cell.detailTextLabel?.text = ""
      return cell
    } else {
      guard let locations = forecastLocations else { return cell }
      cell.textLabel?.text = locations[indexPath.row - 1].locality
      cell.detailTextLabel?.text = locations[indexPath.row - 1].postalCode
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.row == 0 {
      return false
    } else {
      return true
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.store!.deleteForecastLocation(at: indexPath.row - 1)
      self.forecastLocations?.remove(at: indexPath.row - 1)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}

extension LocationSelectVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      forecastLocationDelegate?.setForecastForCurrentLocation()
    } else {
      guard let locations = forecastLocations else { return }
      forecastLocationDelegate?.setForecastLocation(for: locations[indexPath.row - 1])
    }
    self.navigationController?.popViewController(animated: true)
  }
}
