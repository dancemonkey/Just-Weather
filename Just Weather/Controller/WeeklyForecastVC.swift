//
//  WeeklyForecastVC.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/15/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class WeeklyForecastVC: UITableViewController {
  
  var dailyForecast: Forecast.DailyWeather?

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let forecast = self.dailyForecast else { return DailyForecastCell() }
    let cell = tableView.dequeueReusableCell(withIdentifier: "dailyForecastCell", for: indexPath) as! DailyForecastCell
    cell.configure(with: forecast.data[indexPath.row + 1])
    return cell
  }

}
