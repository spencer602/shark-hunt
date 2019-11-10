//
//  DataRetriever.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import Foundation

protocol DataRetrieverProtocol: class {
    func itemsDownloaded(items: [PlayerModel])
}

class DataRetriever: NSObject, URLSessionDataDelegate {
    
    weak var delegate: DataRetrieverProtocol!
    
    var data = Data()
    let urlPath: String = "http://bigskysharkhunt.com/allmatchesjson.php"
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        var players = [PlayerModel]()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let player = PlayerModel()
            
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
                
//                location.name = name
//                location.address = address
//                location.latitude = latitude
//                location.longitude = longitude
                
                player.id = Int(id)
                player.name = name
                player.points = Int(points)
                player.gamesPlayed = Int(gamesPlayed)
                player.gamesWon = Int(gamesWon)
                player.eros = Int(eros)
                player.matchesPlayed = Int(matchesPlayed)
                player.matchesWon = Int(matchesWon)
            }
            
            print(player)
            
            players.append(player)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: players)
            
        })
    }
}
