//
//  WeatherAlertCell.swift
//  Just Weather
//
//  Created by Drew Lanning on 7/24/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class WeatherAlertCell: UITableViewCell {
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeIssuedLbl: UILabel!
  @IBOutlet weak var timeExpiresLbl: UILabel!
  @IBOutlet weak var descriptionLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configure(with alert: Forecast.WeatherAlerts) {
    self.titleLbl.text = alert.title
    self.timeIssuedLbl.text = "Issued: \(Numbers().getTimeAndDate(from: alert.time))"
    self.timeExpiresLbl.text = "Expires: \(Numbers().getTimeAndDate(from: alert.expires))"
    self.descriptionLbl.text = alert.description
  }
  
}
