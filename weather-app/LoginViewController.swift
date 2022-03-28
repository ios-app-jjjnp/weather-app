//
//  LoginViewController.swift
//  weather-app
//
//  Created by Pauline on 3/17/22.
//

import UIKit
import AlamofireImage
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
        {
            (user, error) in
            if user != nil {
                print("logging in")
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
                            UserDefaults.standard.set(settings["zip"], forKey: "zip")
                            UserDefaults.standard.set(settings["lat"], forKey: "lat")
                            UserDefaults.standard.set(settings["long"], forKey: "long")
                            UserDefaults.standard.set(settings["placeName"], forKey: "placeName")
                            UserDefaults.standard.set(settings["stateAbbrv"], forKey: "stateAbbrv")
                            UserDefaults.standard.set(settings["forecast"], forKey: "forecast")
                            UserDefaults.standard.set(settings["hourly"], forKey: "hourly")
                            UserDefaults.standard.set(settings["unitType"], forKey: "unitType")
                        }
                        
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }

            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if error == nil {
                let settings = PFObject(className: "Settings")
                
                settings["userID"] = PFUser.current()
                settings["zip"] = UserDefaults.standard.string(forKey: "zip")
                settings["lat"] = UserDefaults.standard.string(forKey: "lat")
                settings["long"] = UserDefaults.standard.string(forKey: "long")
                settings["placeName"] = UserDefaults.standard.string(forKey: "placeName")
                settings["stateAbbrv"] = UserDefaults.standard.string(forKey: "stateAbbrv")
                settings["forecast"] = UserDefaults.standard.string(forKey: "forecast")
                settings["hourly"] = UserDefaults.standard.string(forKey: "hourly")
                settings["unitType"] = UserDefaults.standard.integer(forKey: "unitType")
                
                settings.saveInBackground { (success, error) in
                    if success {
                        print("new user settings added")
                    } else {
                        print("error setting up new user settings")
                    }
                }
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onGuest(_ sender: Any) {
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
