//
//  DailyForecastCell.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/15/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DailyForecastCell: UITableViewCell {
  
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var dayLbl: UILabel!
  @IBOutlet weak var tempLbl: UILabel!
  @IBOutlet weak var precipLbl: UILabel!
  @IBOutlet weak var summaryLbl: UILabel!
  var labels: [UILabel]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    labels = [dayLbl, tempLbl, precipLbl, summaryLbl]
    clearLabels()
  }
  
  func clearLabels() {
    guard let labels = self.labels else { return }
    for label in labels {
      label.text = "--"
    }
  }
  
  func configure(with forecast: Forecast.DailyWeather.DailyData) {
    icon.image = UIImage(named: forecast.icon)
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    let date = Date(timeIntervalSince1970: forecast.time)
    dayLbl.text = formatter.string(from: date)
    
    let high = Numbers().temperatureFormat(from: forecast.temperatureHigh) + "°"
    let low = Numbers().temperatureFormat(from: forecast.temperatureLow) + "°"
    tempLbl.text = "\(high)/\(low)"
    
    if forecast.precipProbability > 0.05 {
      precipLbl.text = "Precip: \(Numbers().removeDecimals(from: forecast.precipProbability*100))%"
    } else {
      precipLbl.text = ""
    }
    
    summaryLbl.text = forecast.summary
  }
  
}
