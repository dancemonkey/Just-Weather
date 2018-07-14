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
  @IBOutlet weak var humidityLbl: UILabel!
  @IBOutlet weak var dewPointLbl: UILabel!
  @IBOutlet weak var apparentTempLbl: UILabel!
  @IBOutlet weak var rainChanceLbl: UILabel!
  @IBOutlet weak var tomorrowHighTemp: UILabel!
  @IBOutlet weak var tomorrowLowTemp: UILabel!
  @IBOutlet weak var tomorrowIcon: UIImageView!
  @IBOutlet weak var tomorrowSummaryLbl: UILabel!
  @IBOutlet weak var tomorrowChanceOfRainLbl: UILabel!
  var outlets: [UILabel] = [UILabel]()
  
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
  }
  
  // MARK: Helper Functions
  func setupForecastLabels(with forecast: Forecast) {
    self.forecast = forecast
    humidityLbl.text = "\(removeDecimals(from: forecast.currently.humidity*100))%"
    dewPointLbl.text = "\(removeDecimals(from: forecast.currently.dewPoint))°"
    apparentTempLbl.text = "\(removeDecimals(from: forecast.currently.apparentTemperature))°"
    rainChanceLbl.text = "\(removeDecimals(from: forecast.currently.precipProbability*100))%"
    tomorrowHighTemp.text = "High of \(removeDecimals(from: forecast.daily.data[1].temperatureHigh))°"
    tomorrowLowTemp.text = "Low of \(removeDecimals(from: forecast.daily.data[1].temperatureLow))°"
    tomorrowIcon.image = UIImage(named: forecast.daily.data[1].icon)
    tomorrowSummaryLbl.text = "\(forecast.daily.data[1].summary)"
    tomorrowChanceOfRainLbl.text = "Chance of rain: \(removeDecimals(from: forecast.daily.data[1].precipProbability*100))%"
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInfo", for: indexPath)
//
//    return cell
//  }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
