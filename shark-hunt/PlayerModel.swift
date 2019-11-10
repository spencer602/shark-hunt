//
//  PlayerModel.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

class PlayerModel: NSObject {
    
    var id: Int?
    var name: String?
    var points: Int?
    var gamesPlayed: Int?
    var gamesWon: Int?
    var eros: Int?
    var matchesPlayed: Int?
    var matchesWon: Int?
    
    
    override var description: String {
        return "Name: \(name!)"
    }
    
    
}
