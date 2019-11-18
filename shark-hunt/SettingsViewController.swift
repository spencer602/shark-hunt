//
//  SettingsViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/12/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// the view controller managing the settings tab
class SettingsViewController: UITableViewController {

    /// the action outlet for the switch for changing between localhost url and sharkhunt url
    @IBAction func isLocalURLChanged(_ sender: UISwitch) {
        Settings.isLocal = sender.isOn
    }
}
