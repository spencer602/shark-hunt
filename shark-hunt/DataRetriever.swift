//
//  DataRetriever.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

/// A protocol for a class to send a request for data, and have the data delivered back to the (delegate) class (as soon as the data is available)
protocol DataRetrieverProtocol: class {
    /**
     delegate method of DataRetrieverProtocol, this method is called by the DataRetriever with player data **after** the data has been dowloaded and parsed
     
     - Parameter playerData: the array of PlayerModels to be delivered to the delegate
     */
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel])
    
    /**
    delegate method of DataRetrieverProtocol, this method is called by the DataRetriever with match history data **after** the data has been dowloaded and parsed
    
    - Parameter matchHistoryData: the array of MatchModels to be delivered to the delegate
    */
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel])

    /**
    delegate method of DataRetrieverProtocol, this method is called by the DataRetriever with location data **after** the data has been dowloaded and parsed
    
    - Parameter locationNameData: the array of Strings represeting location names to be delivered to the delegate
    */
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String])
}

/// a class for downloading json data from the internet, parsing the data into apropriate arrays, and returning the data back via delegation
class DataRetriever: NSObject, URLSessionDataDelegate {
    
    /// the delegate used to send the downloaded data back
    private weak var delegate: DataRetrieverProtocol!
    
    /**
    Initializes a new DataRetriever with the provided delegate
    - Parameter delegate: the delegate to which the data shoudl be sent back to
    - Returns: the instance of the DataRetriever
    */
    init(withDelegate delegate: DataRetrieverProtocol) {
        self.delegate = delegate
    }
    
    /**
     Downloads the current standings and sends the results to the delegate
        
     Downloads the the player data for all players (the data is already in descending order with respect to points) and sends the array of PlayerModels to the delegate method updatePlayerDataFromDataRetriever(withPlayerData:allPlayers)
     */
    func downloadPlayerData() {
        let urlPath: String = Settings.urlStringPrefix + "currentstandingsjson.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        // the task to be ran (collecting the data), complete with the completion handler
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                // Error
                print("Failed to download data")
            }else {
                // No Error
                var jsonResult = NSArray()
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print(error)
                }
                
                var jsonElement = NSDictionary()
                var allPlayers = [PlayerModel]()
                
                // iterate through players
                for i in 0 ..< jsonResult.count
                {
                    jsonElement = jsonResult[i] as! NSDictionary
                    
                    //gather all player data from the json dictionary using optional binding (if any retrieval fails, the whole retrieval fails
                    if let id = jsonElement["player_id"] as? String,
                        let name = jsonElement["player_name"] as? String,
                        let points = jsonElement["points"] as? String,
                        let gamesPlayed = jsonElement["games_played"] as? String,
                        let gamesWon = jsonElement["games_won"] as? String,
                        let eros = jsonElement["eros"] as? String,
                        let matchesPlayed = jsonElement["matches_played"] as? String,
                        let matchesWon = jsonElement["matches_won"] as? String
                    {
                        // if all of the player data was retrieved successfully, create the PlayerModel
                        let player = PlayerModel(id: Int(id)!, name: name, points: Int(points)!, gamesPlayed: Int(gamesPlayed)!, gamesWon: Int(gamesWon)!, eros: Int(eros)!, matchesPlayed: Int(matchesPlayed)!, matchesWon: Int(matchesWon)!)
                        // append the player to the list of players
                        allPlayers.append(player)
                    }
                }
                
                // once the data is downloaded, send the data back to the delegate asynchronously on the main queue
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.updatePlayerDataFromDataRetriever(withPlayerData: allPlayers)
                })
            }
        }
        // run the task
        task.resume()
    }
    
    /**
     Downloads the location data and sends the results back to the delegate
     
     Downloads the location data (just the name as a String) for all locations (the location data is provided already in alphabetical order). Once the data is downloaded, send the data back to the delegate function updateLocationNameDataFromDataRetriever(withLocationNameData:allLocations)
     */
    func downloadLocationData() {
        let urlPath: String = Settings.urlStringPrefix + "alllocationjson.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
       
        // the task of downloading the data, and a completion handler to handle the data
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                var jsonResult = NSArray()
            
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print(error)
                }
               
                var jsonElement = NSDictionary()
                var allLocations = [String]()
     
                // iterate through the locations
                for i in 0 ..< jsonResult.count
                {
                    jsonElement = jsonResult[i] as! NSDictionary
         
                    // retrieve the location name from the json data
                    if let name = jsonElement["location_name"] as? String
                    {
                        allLocations.append(name)
                    }
                }
                
                // once the data is downloaded, send the data back to the delegate asynchronously on the main queue
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.updateLocationNameDataFromDataRetriever(withLocationNameData: allLocations)
                })
            }
       }
       task.resume()
    }
    
    /**
     Downloads the match data and sends the results back to the delegate
     
     Downloads the match data (already in order, most recent matches first) for all mathes. Once the data is downloaded, send the data back to the delegate function updateMatchHistoryDataFromDataRetriever(withMatchHistoryData:allMatches)
     */
    func downloadMatchHistory() {
        let urlPath: String = Settings.urlStringPrefix + "allmatchesjson.php"

        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        // the task that downloads the data, complete with the completion handler
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
                
                // for every row (match) in the data
                for i in 0 ..< jsonResult.count
                {
                    jsonElement = jsonResult[i] as! NSDictionary
                                   
                    //gather all match data from the json dictionary using optional binding (if any retrieval fails, the whole retrieval fails
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
                        
                        // if the data retrieval suceeds, create a new MatchModel
                        let match = MatchModel(p1Name: p1Name, p2Name: p2Name, p1PointsWagered: Int(p1PointsWagered)!, p2PointsWagered: Int(p2PointsWagered)!, p1GamesNeeded: Int(p1GamesNeeded)!, p2GamesNeeded: Int(p2GamesNeeded)!, p1GamesWon: Int(p1GamesWon)!, p2GamesWon: Int(p2GamesWon)!, p1ERO: Int(p1ERO)!, p2ERO: Int(p2ERO)!, dateAndTime: Date(), locationPlayed: locationPlayed)
                        // append the match to the list of matches
                        allMatches.append(match)
                    }
                }
                
                // once the data is downloaded, send the data back to the delegate asynchronously on the main queue
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.updateMatchHistoryDataFromDataRetriever(withMatchHistoryData: allMatches)
                })
            }
        }
        task.resume()
    }
}
