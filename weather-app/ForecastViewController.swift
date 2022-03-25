//
//  ForecastViewController.swift
//  weather-app
//
//  Created by Pauline on 3/17/22.
//

import UIKit
import AlamofireImage
import Parse

import Alamofire
import SwiftyJSON

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // forecast list
    var forecast = JSON()
    
    // RECIPE FOR TABLE VIEW
    // function for number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    // function for cell in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastCell

        let now = self.forecast[indexPath.row]

        let temp = now["temperature"].rawString()
        let unit = now["temperatureUnit"].rawString()
        
        cell.nameLabel.text = now["name"].rawString()
        cell.tempLabel.text = temp! + " " + unit!
        cell.shortForecast.text = now["shortForecast"].rawString()!

        let iconBase = now["icon"].rawString()!
        let iconURL = URL(string: iconBase)
        cell.iconImage.af.setImage(withURL: iconURL!)

        return cell
    }
    
    
        
    @IBOutlet weak var tableView: UITableView!
    
    
    // This loads the view only the first time
    // Does not change when a new ZIP code is entered
    override func viewDidLoad() {
        print("view loaded")
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 200

        if (UserDefaults.standard.string(forKey: "forecast")?.count ?? 0 > 0) {
            let base = UserDefaults.standard.string(forKey: "forecast")!

            AF.request(base).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.forecast = json["properties"]["periods"]

                    self.tableView.reloadData()
                case .failure(let error):
                    print("error")
                }
            }
        }
    }
}
