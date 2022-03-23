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

class ForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // forecast list
    var forecast = [[String:Any]]()
    
    // RECIPE FOR TABLE VIEW
    // function for number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    // function for cell in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        let one_cell = now[indexPath.row]
//        let temp = one_cell["temperature"].rawString()
//        cell.textLabel!.text = "row: \(indexPath.row)"
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

        
//         Do any additional setup after loading the view.
        
        print(UserDefaults.standard.string(forKey: "hourly"))

        if (UserDefaults.standard.string(forKey: "hourly")?.count ?? 0 > 0) {
            let base = UserDefaults.standard.string(forKey: "hourly")!
            AF.request(base).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let now = json["properties"]["periods"]
                    print(now)
                    
                    // TODO: need to put "now" into "forecast" variable (created at top) so tableview can use it.
                    
                    // this is wrong
//                    let forecastDictionary = try! JSONSerialization.jsonObject(with: now, options: []) as! [String: Any]
//                    self.forecast = forecastDictionary["??"] as! [[String:Any]]
                    
                    
                    
//                    let temp = now["temperature"].rawString()
//                    let unit = now["temperatureUnit"].rawString()
//                    let place = UserDefaults.standard.string(forKey: "placeName")
//                    let state = UserDefaults.standard.string(forKey: "stateAbbrv")

//                    self.locationLabel.text = place! + ", " + state!
//
//                    self.tempLabel.text = temp! + " " + unit!
//                    self.shortForecast.text = now["shortForecast"].rawString()!
//
//                    let iconBase = now["icon"].rawString()!
//                    let iconURL = URL(string: iconBase)
//                    self.iconNow.af.setImage(withURL: iconURL!)

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
        


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
