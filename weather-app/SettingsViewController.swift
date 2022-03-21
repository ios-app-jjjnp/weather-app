//
//  SettingsViewController.swift
//  weather-app
//
//  Created by Pauline on 3/17/22.
//

import UIKit
import AlamofireImage
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var zipcodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (UserDefaults.standard.string(forKey: "zip")?.count ?? 0 > 0) {
            zipcodeField.text = UserDefaults.standard.string(forKey: "zip")
        }
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        //TODO, ideally add a simple zip code validation
        UserDefaults.standard.set(zipcodeField.text, forKey: "zip")
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
