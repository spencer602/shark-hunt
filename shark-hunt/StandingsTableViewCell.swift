//
//  StandingsTableViewCell.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/14/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var detailThreeLabel: UILabel!
    @IBOutlet weak var detailOneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
