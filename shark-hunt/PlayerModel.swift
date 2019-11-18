//
//  PlayerModel.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

/// A player with unique id
struct PlayerModel: CustomStringConvertible, Equatable {
    
    /// the unique identifier
    let id: Int
    /// the player name
    let name: String
    /// the players current points
    let points: Int
    /// the games that have been played by the player
    let gamesPlayed: Int
    /// the games that have been won by the player
    let gamesWon: Int
    /// the number of eros the player has completed
    let eros: Int
    /// the number of matches the player has played
    let matchesPlayed: Int
    /// the number of matches the player has won
    let matchesWon: Int
    
    /**
    Returns the equality of two players by comparing the equality of their ids

    - Parameter lhs: the first player to be compared
    - Parameter rhs: the second player to be compared
     
    - Returns: true if the player's ids are equal, false otherwise
    */
    static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// returns the String description of the player, current implemention only includes 'Name: ' followed by the players name property
    var description: String {
        return "Name: \(name)"
    }
}
