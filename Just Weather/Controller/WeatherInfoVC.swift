//
//  WeatherInfoVC.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/10/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class WeatherInfoVC: UITableViewController {
  
  var forecast: Forecast?
  var hourlyForecast: Forecast.HourlyWeather?
  @IBOutlet weak var humidityLbl: UILabel!
  @IBOutlet weak var dewPointLbl: UILabel!
  @IBOutlet weak var apparentTempLbl: UILabel!
  @IBOutlet weak var rainChanceLbl: UILabel!
  @IBOutlet weak var tomorrowHighTemp: UILabel!
  @IBOutlet weak var tomorrowLowTemp: UILabel!
  @IBOutlet weak var tomorrowIcon: UIImageView!
  @IBOutlet weak var tomorrowSummaryLbl: UILabel!
  @IBOutlet weak var tomorrowChanceOfRainLbl: UILabel!
  @IBOutlet weak var hourlyForecastCollection: UICollectionView!
  var outlets: [UILabel] = [UILabel]()
  weak var segueDelegate: SegueHandler?
  let dailyForecastSelectableRow = 6
  
  enum cellIndexPath: Int {
    case humidity = 0
    case dewPoint
    case apparentTemp
    case chanceOfRain
    case tomorrowHeader
    case tomorrowWeather
    case tomorrowSummary
    case tomorrowChanceOfRain
    case futureDisclosure
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    outlets = [humidityLbl, dewPointLbl, apparentTempLbl, rainChanceLbl, tomorrowHighTemp, tomorrowLowTemp, tomorrowSummaryLbl, tomorrowChanceOfRainLbl]
    for outlet in outlets {
      outlet.text = "--"
      outlet.textColor = UIColor(named: "PrimaryText")
    }
    hourlyForecastCollection.delegate = self
    hourlyForecastCollection.dataSource = self
  }
  
  // MARK: Helper Functions
  func setupForecastLabels(with forecast: Forecast) {
    self.forecast = forecast
    self.hourlyForecast = forecast.hourly
    humidityLbl.text = "\(Numbers().removeDecimals(from: forecast.currently.humidity*100))%"
    dewPointLbl.text = "\(Numbers().removeDecimals(from: forecast.currently.dewPoint))°"
    apparentTempLbl.text = "\(Numbers().removeDecimals(from: forecast.currently.apparentTemperature))°"
    rainChanceLbl.text = "\(Numbers().removeDecimals(from: forecast.currently.precipProbability*100))%"
    tomorrowHighTemp.text = "High of \(Numbers().removeDecimals(from: forecast.daily.data[1].temperatureHigh))°"
    tomorrowLowTemp.text = "Low of \(Numbers().removeDecimals(from: forecast.daily.data[1].temperatureLow))°"
    tomorrowIcon.image = UIImage(named: forecast.daily.data[1].icon)
    tomorrowSummaryLbl.text = "\(forecast.daily.data[1].summary)"
    tomorrowChanceOfRainLbl.text = "Chance of precipitation: \(Numbers().removeDecimals(from: forecast.daily.data[1].precipProbability*100))%"
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 9
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == dailyForecastSelectableRow {
      segueDelegate?.segueTo(identifier: "showWeeklyForecast")
    }
  }
}

extension WeatherInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = hourlyForecastCollection.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyItemCell
    if let hourlyData = self.hourlyForecast?.data {
      cell.configure(from: hourlyData[indexPath.row])
      if indexPath.row == 0 {
        cell.timeLbl.text = "Now"
      }
    } else {
      cell.configureWaiting()
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 12
  }
  
}
