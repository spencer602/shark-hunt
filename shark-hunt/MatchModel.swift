//
//  MatchModel.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

struct MatchModel: CustomStringConvertible {
    var p1Name: String
    var p2Name: String
    var p1PointsWagered: Int
    var p2PointsWagered: Int
    var p1GamesNeeded: Int
    var p2GamesNeeded: Int
    var p1GamesWon: Int
    var p2GamesWon: Int
    var p1ERO: Int
    var p2ERO: Int
    var dateAndTime: Date
    var locationPlayed: String
    
    var description: String {
        return p1Name
    }
    
    var upperText: String {
        return "\(p1Name): \(p1GamesWon)/\(p1GamesNeeded)"
    }
    
    var lowerText: String {
        return "\(p2Name): \(p2GamesWon)/\(p2GamesNeeded)"
    }
    
}


