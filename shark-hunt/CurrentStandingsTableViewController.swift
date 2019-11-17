//
//  CurrentStandingsTableViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class CurrentStandingsTableViewController: UITableViewController, DataRetrieverProtocol {
    
    var dr: DataRetriever?
    var players = [PlayerModel]()

    @IBOutlet var listTableView: UITableView!
    
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {
        self.players = playerData
        listTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dr = DataRetriever(withDelegate: self)
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dr?.downloadPlayerData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell")!
        
        if let myStandingCell = cell as? StandingsTableViewCell {
            // Get the location to be shown
            let item = players[indexPath.row]
            // Get references to labels of cell
            
            myStandingCell.rankLabel.text = String(indexPath.row + 1)
            myStandingCell.titleLabel.text = String(item.points) + "   " + item.name
            myStandingCell.detailOneLabel.text = "Matches: " + (item.matchesPlayed != 0 ? String((100 * Double(item.matchesWon)/Double(item.matchesPlayed)).easyToReadNotation(withDecimalPlaces: 1)) : "NA") + "% (\(item.matchesWon)/\(item.matchesPlayed))"
            myStandingCell.detailThreeLabel.text = "Games: " + (item.gamesPlayed != 0 ? String((100 * Double(item.gamesWon)/Double(item.gamesPlayed)).easyToReadNotation(withDecimalPlaces: 1)) : "NA") + "% (\(item.gamesWon)/\(item.gamesPlayed))  -  ERO: \(item.eros)"
        }

        return cell
    }

    // unused
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) { }
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PersonalMatchHistoryViewController {
            if let plyr = sender as? StandingsTableViewCell {
                if let selectedRow = listTableView.indexPathForSelectedRow {
                    dest.player = players[selectedRow.row]
                }
                
            }
        }
    }
}
