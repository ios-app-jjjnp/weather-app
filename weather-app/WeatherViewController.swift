//
//  WeatherViewController.swift
//  weather-app
//
//  Created by Pauline on 3/17/22.
//

import UIKit
import AlamofireImage
import Alamofire
import Parse
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var iconNow: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var shortForecast: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // This loads the view only the first time
    // Does not change when a new ZIP code is entered
    override func viewDidLoad() {
        print("view loaded")
        
        // Do any additional setup after loading the view.
//        loadWeather()
    }
        
    // Reloads the page every time you look at the current weather
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        loadWeather()
    }
    
    func loadWeather() {
        if (UserDefaults.standard.string(forKey: "hourly")?.count ?? 0 > 0) {
            let base = UserDefaults.standard.string(forKey: "hourly")!

            AF.request(base).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let now = json["properties"]["periods"][0]
                    var temp = now["temperature"].rawString()
                    var unit = now["temperatureUnit"].rawString()
                    let place = UserDefaults.standard.string(forKey: "placeName")
                    let state = UserDefaults.standard.string(forKey: "stateAbbrv")
                    
                    // Check if the user wants celcius. Assume that API always passes units as F
                    if(UserDefaults.standard.integer(forKey: "unitType") == 1) {
                        var numTemp = Double(temp!) ?? 32.0
                        numTemp = (numTemp - 32.0) * (5.0/9.0)
                        temp = String(format: "%.1f", numTemp)
                        unit = "C"
                    }
                    
                    
                    self.locationLabel.text = place! + ", " + state!
                    
                    self.tempLabel.text = temp! + " " + unit!
                    self.shortForecast.text = now["shortForecast"].rawString()!
                    
                    let iconBase = now["icon"].rawString()!
                    let iconURL = URL(string: iconBase)
                    self.iconNow.af.setImage(withURL: iconURL!)
                    
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
