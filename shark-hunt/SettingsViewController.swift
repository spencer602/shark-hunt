//
//  SettingsViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/12/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBAction func isLocalURLChanged(_ sender: UISwitch) {
        Settings.isLocal = sender.isOn

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
