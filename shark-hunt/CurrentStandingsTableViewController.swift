//
//  CurrentStandingsTableViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class CurrentStandingsTableViewController: UITableViewController, DataRetrieverProtocol {
    
    var players = [PlayerModel]()
    
    func itemsDownloaded(items: [PlayerModel]) {
        players = items
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
        var standings = [PlayerModel]()
        
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
            
//            if let p1Name = jsonElement["p1name"] as? String,    // name
//                let p2Name = jsonElement["p2name"] as? String,   // name
//                let p1PointsWagered = jsonElement["p1_points_wagered"] as? String,
//                let p2PointsWagered = jsonElement["p2_points_wagered"] as? String,
//                let p1GamesNeeded = jsonElement["p1_games_needed"] as? String,
//                let p2GamesNeeded = jsonElement["p2_games_needed"] as? String,
//                let p1GamesWon = jsonElement["p1_games_won"] as? String,
//                let p2GamesWon = jsonElement["p2_games_won"] as? String,
//                let p1ERO = jsonElement["p1_ero"] as? String,
//                let p2ERO = jsonElement["p2_ero"] as? String,
//                let dateAndTime = jsonElement["date_and_time"] as? String,
//                let locationPlayed = jsonElement["location_played"] as? String
//            {
                
                let standing = PlayerModel(id: Int(id)!, name: name, points: Int(points)!, gamesPlayed: Int(gamesPlayed)!, gamesWon: Int(gamesWon)!, eros: Int(eros)!, matchesPlayed: Int(matchesPlayed)!, matchesWon: Int(matchesWon)!)

            
                
//                location.name = name
//                location.address = address
//                location.latitude = latitude
//                location.longitude = longitude
                
                standings.append(standing)

            }
            
            //print(player)
            
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.itemsDownloaded(items: standings)
            
        })
    }
    
    @IBOutlet var listTableView: UITableView!
    
    var urlString: String { return "http://bigskysharkhunt.com/currentstandingsjson.php" }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let dr = DataRetriever()
        dr.delegate = self

        dr.downloadItems()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        players.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicStandingsCell")!
        
        if let myStandingCell = cell as? MatchTableViewCell {
            // Get the location to be shown
            let item = players[indexPath.row]
            // Get references to labels of cell
            myStandingCell.upperLabel.text = "\(indexPath.row) " + item.upperText
            myStandingCell.lowerLabel.text = item.lowerText
        }

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
