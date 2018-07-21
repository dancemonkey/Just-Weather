//
//  LocationSearchVC.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // optional string for now, eventually need custom model result?
  var searchResults: [CLPlacemark]?
  var zipHandlerDelegate: ZipCodeHandler?
  var fetcher: WeatherFetcher?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.searchBar.delegate = self
  }
  
  // MARK: Tableview functions
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let results = self.searchResults else { return 1 }
    return results.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
    if indexPath.row == 0 {
      cell.textLabel?.text = "Current Location"
      cell.imageView?.image = UIImage(named: "pin")
      return cell
    } else {
      guard let results = searchResults else {
        cell.textLabel?.text = "No Result Found"
        return cell
      }
      let result = results[indexPath.row - 1]
      let locationResult: (city: String, state: String, zip: String) = (result.locality ?? "", result.administrativeArea ?? "", result.postalCode ?? "")
      cell.textLabel?.text = "\(locationResult.city) \(locationResult.state) \(locationResult.zip)"
      cell.imageView?.image = nil
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      zipHandlerDelegate?.setForecastForCurrentLocation()
    } else {
      guard let results = self.searchResults else { return }
      zipHandlerDelegate?.setForecastLocation(for: results[indexPath.row-1])
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Searchbar functions
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let fetcher = self.fetcher else { return }
    fetcher.getLocation(for: searchBar.text) { (placemarks) in
      self.searchResults = placemarks
      self.tableView.reloadData()
    }
  }
  
}
