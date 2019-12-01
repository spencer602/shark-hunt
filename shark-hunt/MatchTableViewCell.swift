//
//  MatchTableViewCell.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for displaying details of a match in a table view cell
class MatchTableViewCell: UITableViewCell {
    @IBOutlet weak var losingPlayerLabel: UILabel!
    @IBOutlet weak var winningPlayerLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
}
