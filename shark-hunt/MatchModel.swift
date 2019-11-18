//
//  MatchModel.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

/// a match with all relevant details captured
struct MatchModel {
    /// the name of the first player in the match
    let p1Name: String
    /// the name of the second player in the match
    let p2Name: String
    /// the points wagered by player 1
    let p1PointsWagered: Int
    /// the points wagered by player 2
    let p2PointsWagered: Int
    /// the games needed by player 1 to win
    let p1GamesNeeded: Int
    /// the games needed by player 2 to win
    let p2GamesNeeded: Int
    /// the games won by player 1
    let p1GamesWon: Int
    /// the games won by player 2
    let p2GamesWon: Int
    /// the amount of eros by player 1 in this match
    let p1ERO: Int
    /// the amount of eros by player 2 in this match
    let p2ERO: Int
    /// the date and time of the match
    let dateAndTime: Date
    /// the name of the location where the match was played
    let locationPlayed: String

    /// true if player 1 won, false if player 1 lost
    var p1Won: Bool { return p1GamesWon == p1GamesNeeded }
    
    /// the amount of points that were won/lost (the amounts of points wagered by the losing player is the amount of points that are won and lost)
    var dPoints: Int { return p1Won ? p2PointsWagered : p1PointsWagered }
    
    /// a simple rundown of the match for player 1: name, points won/lost wins, wins needed, and number of eros (eros omitted if there are none for player 1)
    var p1Text: String {
        return "\(p1Name) \(p1Won ? "+" : "-")\(dPoints):   \(p1GamesWon)/\(p1GamesNeeded)   \(p1ERO > 0 ? "ERO: \(p1ERO)": "")"
    }
    
    /// a simple rundown of the match for player 2: name, points won/lost wins, wins needed, and number of eros (eros omitted if there are none for player 2)
    var p2Text: String {
        return "\(p2Name) \(p1Won ? "-" : "+")\(dPoints):   \(p2GamesWon)/\(p2GamesNeeded)   \(p2ERO > 0 ? "ERO: \(p2ERO)": "")"
    }
}
