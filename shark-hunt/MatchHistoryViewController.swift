//
//  MatchHistoryViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class MatchHistoryViewController: UIViewController, DataRetrieverProtocol, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicMatchHistoryCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        if let myMatchCell = myCell as? MatchTableViewCell {
            // Get the location to be shown
            let item = matches[indexPath.row]
            // Get references to labels of cell
            myMatchCell.upperLabel.text = item.upperText
            myMatchCell.lowerLabel.text = item.lowerText
        }
        
        return myCell
    }
    
    var urlString: String { return "http://bigskysharkhunt.com/allmatchesjson.php" }
    
    var matches = [MatchModel]()
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let dr = DataRetriever()
        dr.delegate = self

        dr.downloadItems()

        // Do any additional setup after loading the view.
    }
    
    
    func itemsDownloaded(items: [MatchModel]) {
        matches = items
        self.listTableView.reloadData()

    }
    
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
                    
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        var matches = [MatchModel]()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            
            
            
            //the following insures none of the JsonElement values are nil through optional binding
//                if let id = jsonElement["player_id"] as? String,
//                    let name = jsonElement["player_name"] as? String,
//                    let points = jsonElement["points"] as? String,
//                    let gamesPlayed = jsonElement["games_played"] as? String,
//                    let gamesWon = jsonElement["games_won"] as? String,
//                    let eros = jsonElement["eros"] as? String,
//                    let matchesPlayed = jsonElement["matches_played"] as? String,
//                    let matchesWon = jsonElement["matches_won"] as? String
//                {
            
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

            
                
//                location.name = name
//                location.address = address
//                location.latitude = latitude
//                location.longitude = longitude
                
                matches.append(match)

            }
            
            //print(player)
            
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.itemsDownloaded(items: matches)
            
        })
    }
    
   
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
