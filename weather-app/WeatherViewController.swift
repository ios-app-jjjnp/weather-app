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
        
        print(UserDefaults.standard.string(forKey: "hourly"))
        
        if (UserDefaults.standard.string(forKey: "hourly")?.count ?? 0 > 0) {
            let base = UserDefaults.standard.string(forKey: "hourly")!
            
            print(base)
            
            AF.request(base).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let now = json["properties"]["periods"][0]
                    let temp = now["temperature"].rawString()
                    let unit = now["temperatureUnit"].rawString()
                    let place = UserDefaults.standard.string(forKey: "placeName")
                    let state = UserDefaults.standard.string(forKey: "stateAbbrv")
                    
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
        
    // Reloads the page every time you look at the current weather
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        print("view appeared")

        print(UserDefaults.standard.string(forKey: "hourly"))

        if (UserDefaults.standard.string(forKey: "hourly")?.count ?? 0 > 0) {
            let base = UserDefaults.standard.string(forKey: "hourly")!
            
            print("base is", base)
            
            AF.request(base).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let now = json["properties"]["periods"][0]
                    
                    print("now is", now)
                                       
                    let temp = now["temperature"].rawString()
                    let unit = now["temperatureUnit"].rawString()
                    let place = UserDefaults.standard.string(forKey: "placeName")
                    let state = UserDefaults.standard.string(forKey: "stateAbbrv")

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
