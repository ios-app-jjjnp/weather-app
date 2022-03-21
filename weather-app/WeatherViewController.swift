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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(UserDefaults.standard.string(forKey: "hourly"))
        
        if (UserDefaults.standard.string(forKey: "hourly")?.count ?? 0 > 0) {
            let base = UserDefaults.standard.string(forKey: "hourly")!
            AF.request(base).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let now = json["properties"]["periods"][0]
                    let temp = now["temperature"].rawString()
                    let unit = now["temperatureUnit"].rawString()
                    
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
