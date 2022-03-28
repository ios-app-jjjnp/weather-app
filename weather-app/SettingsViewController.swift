//
//  SettingsViewController.swift
//  weather-app
//
//  Created by Pauline on 3/17/22.
//

import UIKit
import AlamofireImage
import Alamofire
import Parse
import SwiftyJSON

class SettingsViewController: UIViewController {

    @IBOutlet weak var zipcodeField: UITextField!
    
    @IBOutlet weak var unitControl: UISegmentedControl!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (UserDefaults.standard.string(forKey: "zip")?.count ?? 0 > 0) {
            zipcodeField.text = UserDefaults.standard.string(forKey: "zip")
        }
        
        // if no initial value assigned, it should default to 0
        unitControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "unitType")
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        //TODO, ideally add a simple zip code validation
        UserDefaults.standard.set(zipcodeField.text, forKey: "zip")
        
        // Realistically, this request chain should be done with whatever promise mechanism exists in swift
        // this is a really ugly hack for now
        if (UserDefaults.standard.string(forKey: "zip")?.count ?? 0 > 0) {
            let base = "https://ios-app-jjjnp.github.io/data/" + UserDefaults.standard.string(forKey: "zip")! + ".json"
//            print(base)
            AF.request(base).validate().responseJSON { response in
                switch response.result {
                    case .success(let value):
                    let json = JSON(value)
//                    print(json["lat"])
                    UserDefaults.standard.set(json["lat"].rawString(), forKey: "lat")
                    UserDefaults.standard.set(json["long"].rawString(), forKey: "long")
                    UserDefaults.standard.set(json["place_name"].rawString(), forKey: "placeName")
                    UserDefaults.standard.set(json["state_abbrv"].rawString(), forKey: "stateAbbrv")
                        
                    let gridBase = "https://api.weather.gov/points/" + json["lat"].rawString()! + "," + json["long"].rawString()!
                    
                    AF.request(gridBase).validate().responseJSON { response in
                        switch response.result {
                            case .success(let value):
                            let json = JSON(value)
                            let props = json["properties"]
                            UserDefaults.standard.set(props["forecast"].rawString(), forKey: "forecast")
                            UserDefaults.standard.set(props["forecastHourly"].rawString(), forKey: "hourly")
                            
                            if (PFUser.current() != nil) {
                                //as a simplification, always assume the user exists in the database
                                let query = PFQuery(className: "Settings")
                                
                                query.whereKey("userID", equalTo: PFUser.current())
                                query.findObjectsInBackground { (objects:[PFObject]?, error: Error?)
                                    in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else if let objects = objects {
                                        
                                        // there should only be one matching object unless something went wrong
                                        // ideally there'd be a check
                                        for settings in objects {
                                            settings["zip"] = UserDefaults.standard.string(forKey: "zip")
                                            settings["lat"] = UserDefaults.standard.string(forKey: "lat")
                                            settings["long"] = UserDefaults.standard.string(forKey: "long")
                                            settings["placeName"] = UserDefaults.standard.string(forKey: "placeName")
                                            settings["stateAbbrv"] = UserDefaults.standard.string(forKey: "stateAbbrv")
                                            settings["forecast"] = UserDefaults.standard.string(forKey: "forecast")
                                            settings["hourly"] = UserDefaults.standard.string(forKey: "hourly")

                                            settings.saveInBackground { (success, error) in
                                                if success {
                                                    print("saved settings")
                                                } else {
                                                    print("error saving settings")
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    
    @IBAction func unitChanged(_ sender: Any) {
        UserDefaults.standard.set(unitControl.selectedSegmentIndex, forKey: "unitType")
        
        if (PFUser.current() != nil) {
            //as a simplification, always assume the user exists in the database
            let query = PFQuery(className: "Settings")
            
            query.whereKey("userID", equalTo: PFUser.current())
            query.findObjectsInBackground { (objects:[PFObject]?, error: Error?)
                in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    
                    // there should only be one matching object unless something went wrong
                    // ideally there'd be a check
                    for settings in objects {
                        settings["unitType"] = UserDefaults.standard.integer(forKey: "unitType")

                        settings.saveInBackground { (success, error) in
                            if success {
                                print("saved settings")
                            } else {
                                print("error saving settings")
                            }
                        }
                    }
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
