//
//  WeatherAlertVC.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/24/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class WeatherAlertVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var weatherAlerts = [Forecast.WeatherAlerts]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 150
    self.title = "\(weatherAlerts.count) Weather Alert" + (weatherAlerts.count > 1 ? "s" : "")
  }
}

extension WeatherAlertVC: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherAlerts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "weatherAlertCell") as! WeatherAlertCell
    cell.configure(with: weatherAlerts[indexPath.row])
    return cell
  }
  
}

extension WeatherAlertVC: UITableViewDelegate {
  
}
