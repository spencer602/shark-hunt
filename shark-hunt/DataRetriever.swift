//
//  DataRetriever.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

protocol DataRetrieverProtocol: class {
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel])
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel])
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String])
}

class DataRetriever: NSObject, URLSessionDataDelegate {
    
    init(withDelegate delegate: DataRetrieverProtocol) {
        self.delegate = delegate
    }
    
    weak var delegate: DataRetrieverProtocol!
    
    func downloadPlayerData() {
        let urlPath: String = Settings.urlStringPrefix + "currentstandingsjson.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")

                var jsonResult = NSArray()
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print(error)
                }
                
                var jsonElement = NSDictionary()
                var allPlayers = [PlayerModel]()
                
                for i in 0 ..< jsonResult.count
                {
                    jsonElement = jsonResult[i] as! NSDictionary
                    
                    //the following insures none of the JsonElement values are nil through optional binding
                    if let id = jsonElement["player_id"] as? String,
                        let name = jsonElement["player_name"] as? String,
                        let points = jsonElement["points"] as? String,
                        let gamesPlayed = jsonElement["games_played"] as? String,
                        let gamesWon = jsonElement["games_won"] as? String,
                        let eros = jsonElement["eros"] as? String,
                        let matchesPlayed = jsonElement["matches_played"] as? String,
                        let matchesWon = jsonElement["matches_won"] as? String
                    {
                        let player = PlayerModel(id: Int(id)!, name: name, points: Int(points)!, gamesPlayed: Int(gamesPlayed)!, gamesWon: Int(gamesWon)!, eros: Int(eros)!, matchesPlayed: Int(matchesPlayed)!, matchesWon: Int(matchesWon)!)
                        allPlayers.append(player)
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.updatePlayerDataFromDataRetriever(withPlayerData: allPlayers)
                })
            }
        }
        task.resume()
    }
    
    func downloadLocationData() {
        let urlPath: String = Settings.urlStringPrefix + "alllocationjson.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
       
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
          
                var jsonResult = NSArray()
            
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print(error)
                }
               
                var jsonElement = NSDictionary()
                var allLocations = [String]()
     
                for i in 0 ..< jsonResult.count
                {
                    jsonElement = jsonResult[i] as! NSDictionary
         
                    //the following insures none of the JsonElement values are nil through optional binding
                    if let name = jsonElement["location_name"] as? String
                    {
                        allLocations.append(name)
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.updateLocationNameDataFromDataRetriever(withLocationNameData: allLocations)
                })
            }
       }
       task.resume()
    }
    
    func downloadMatchHistory() {
        let urlPath: String = Settings.urlStringPrefix + "allmatchesjson.php"

        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                var jsonResult = NSArray()
                                    
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                    
                } catch let error as NSError {
                    print(error)
                    
                }
                
                var jsonElement = NSDictionary()
                var allMatches = [MatchModel]()
                
                for i in 0 ..< jsonResult.count
                {
                    
                    jsonElement = jsonResult[i] as! NSDictionary
                                           
                    if let p1Name = jsonElement["p1name"] as? String,    // name
                        let p2Name = jsonElement["p2name"] as? String,   // name
                        let p1PointsWagered = jsonElement["p1_points_wagered"] as? String,
                        let p2PointsWagered = jsonElement["p2_points_wagered"] as? String,
                        let p1GamesNeeded = jsonElement["p1_games_needed"] as? String,
                        let p2GamesNeeded = jsonElement["p2_games_needed"] as? String,
                        let p1GamesWon = jsonElement["p1_games_won"] as? String,
                        let p2GamesWon = jsonElement["p2_games_won"] as? String,
                        let p1ERO = jsonElement["p1_ero"] as? String,
                        let p2ERO = jsonElement["p2_ero"] as? String,
                        let dateAndTime = jsonElement["date_and_time"] as? String,
                        let locationPlayed = jsonElement["location_played"] as? String
                    {
                        
                    let match = MatchModel(p1Name: p1Name, p2Name: p2Name, p1PointsWagered: Int(p1PointsWagered)!, p2PointsWagered: Int(p2PointsWagered)!, p1GamesNeeded: Int(p1GamesNeeded)!, p2GamesNeeded: Int(p2GamesNeeded)!, p1GamesWon: Int(p1GamesWon)!, p2GamesWon: Int(p2GamesWon)!, p1ERO: Int(p1ERO)!, p2ERO: Int(p2ERO)!, dateAndTime: Date(), locationPlayed: locationPlayed)

                        allMatches.append(match)
                    }
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.updateMatchHistoryDataFromDataRetriever(withMatchHistoryData: allMatches)
                })
            }
        }
        task.resume()
    }
}
