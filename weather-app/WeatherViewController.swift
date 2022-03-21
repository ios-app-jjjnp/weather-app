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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(UserDefaults.standard.string(forKey: "hourly"))
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
