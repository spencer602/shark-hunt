//
//  CurrentStandingsTableViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for displaying the current standings
class CurrentStandingsTableViewController: UITableViewController, DataRetrieverProtocol {
    
    private var dr: DataRetriever?
    private var players = [PlayerModel]()

    @IBOutlet private var listTableView: UITableView!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dr = DataRetriever(withDelegate: self)
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // initial download of the player data
        dr?.downloadPlayerData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PersonalMatchHistoryViewController {
            if let _ = sender as? StandingsTableViewCell {
                if let selectedRow = listTableView.indexPathForSelectedRow {
                    dest.prepareForBeingSeguedTo(withPlayer: players[selectedRow.row])
                }
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell")!
        
        if let myStandingCell = cell as? StandingsTableViewCell {
            // Get the location to be shown
            let item = players[indexPath.row]
            // Get references to labels of cell
            
            myStandingCell.setRankLabel(withString: String(indexPath.row + 1))
            myStandingCell.setTitleLabel(withString: String(item.points) + "   " + item.name)
            myStandingCell.setDetailOneLabel(withString: "Matches: " + (item.matchesPlayed != 0 ? String((100 * Double(item.matchesWon)/Double(item.matchesPlayed)).easyToReadNotation(withDecimalPlaces: 1)) : "NA") + "% (\(item.matchesWon)/\(item.matchesPlayed))")
            myStandingCell.setDetailTwoLabel(withString: "Games: " + (item.gamesPlayed != 0 ? String((100 * Double(item.gamesWon)/Double(item.gamesPlayed)).easyToReadNotation(withDecimalPlaces: 1)) : "NA") + "% (\(item.gamesWon)/\(item.gamesPlayed))  -  ERO: \(item.eros)")
        }

        return cell
    }
    
    // MARK: - Delegate methods for DataRetriever
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {
        self.players = playerData
        listTableView.reloadData()
    }
    
    // unused delegate methods from DataRetriever
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) { }
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) { }
}
