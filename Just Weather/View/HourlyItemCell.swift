//
//  HourlyItemCell.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/15/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class HourlyItemCell: UICollectionViewCell {
  
  @IBOutlet weak var timeLbl: UILabel!
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var temperatureLbl: UILabel!
  @IBOutlet weak var chanceOfRainLbl: UILabel!
  
  func configure(from forecastData: Forecast.HourlyWeather.HourlyData) {
    timeLbl.text = getHour(from: forecastData.time)
    weatherIcon.image = UIImage(named: forecastData.icon)
    temperatureLbl.text = Numbers().temperatureFormat(from: forecastData.temperature) + "°"
    if forecastData.precipProbability >= 1.0 {
      chanceOfRainLbl.text = Numbers().removeDecimals(from: forecastData.precipProbability) + "%"
    } else {
      chanceOfRainLbl.text = ""
    }
  }
  
  func configureWaiting() {
    timeLbl.text = ""
    temperatureLbl.text = ""
    chanceOfRainLbl.text = ""
  }
  
  func getHour(from time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    let formatter = DateFormatter()
    formatter.dateFormat = "h a"
    return formatter.string(from: date)
  }
  
}
