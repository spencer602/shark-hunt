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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicStandingsCell")!
        
        if let myStandingCell = cell as? MatchTableViewCell {
            // Get the location to be shown
            let item = players[indexPath.row]
            // Get references to labels of cell
            myStandingCell.upperLabel.text = "\(indexPath.row + 1) --  Points: \(item.points)  \(item.name)"
            myStandingCell.lowerLabel.text = "Games:\(item.gamesWon)/\(item.gamesPlayed)   Matches: \(item.matchesWon)/\(item.matchesPlayed)"
        }

        return cell
    }

    // unused
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) { }
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) { }
}
