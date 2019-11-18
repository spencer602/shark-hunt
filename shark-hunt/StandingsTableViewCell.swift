//
//  StandingsTableViewCell.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/14/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {
    
    ///outlet to detailOneLabel which displays:  "matches 100% (2/2)"
    @IBOutlet private weak var detailOneLabel: UILabel!
    
    /// outlet to detailTwoLabel which displays: "games 58% (10/17)"
    @IBOutlet private weak var detailTwoLabel: UILabel!
    
    /// outlet to titleLabel which displays the amount of points followed by the player name
    @IBOutlet private weak var titleLabel: UILabel!
    
    /// outlet to the rank label which displays the players current rank with respect to points
    @IBOutlet private weak var rankLabel: UILabel!
    
    /**
     sets the text in detailOneLabel
     
     - Parameter text: the text to be given to detailOneLabel
     */
    func setDetailOneLabel(withString text: String) {
        detailOneLabel.text = text
    }
    
    /**
    sets the text in detailTwoLabel
    
    - Parameter text: the text to be given to detailTwoLabel
    */
    func setDetailTwoLabel(withString text: String) {
        detailTwoLabel.text = text
    }
    
    /**
    sets the text in titleLabel
    
    - Parameter text: the text to be given to titleLabel
    */
    func setTitleLabel(withString text: String) {
        titleLabel.text = text
    }
    
    /**
    sets the text in rankLabel
    
    - Parameter text: the text to be given to rankLabel
    */
    func setRankLabel(withString text: String) {
        rankLabel.text = text
    }
}
