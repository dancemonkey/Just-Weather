//
//  LocationSearchVC.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class LocationSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // optional string for now, eventually need custom model result?
  var searchResults: [String]?
  var zipHandlerDelegate: ZipCodeHandler?
  var fetcher: WeatherFetcher?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.searchBar.delegate = self
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let results = self.searchResults else { return 1 }
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
    guard let results = self.searchResults else {
      cell.textLabel?.text = "Current Location"
      cell.imageView?.image = UIImage(named: "pin")
      return cell
    }
    cell.textLabel?.text = results[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let results = self.searchResults else {
      zipHandlerDelegate?.setForecastForCurrentLocation()
      self.navigationController?.popViewController(animated: true)
      return
    }
    // run forecast for location in table row tapped
  }
  
}
