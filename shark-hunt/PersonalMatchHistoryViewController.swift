//
//  PersonalMatchHistoryViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/17/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class PersonalMatchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataRetrieverProtocol {
    
    var player: PlayerModel!
    var matches = [MatchModel]()
    var dr: DataRetriever?
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // start the process of downloading match history data, result of the download will be passed with delegate call to updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData)
        dr?.downloadPersonalMatchHistory(withPlayerID: player.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dr = DataRetriever(withDelegate: self)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    // delegate method, called from dataRetriever, gets the matches data
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) {
        //filter the matches to only those with the player involved
        matches = matchHistoryData.filter { $0.p1Name == player.name || $0.p2Name == player.name }
        listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicMatchHistoryCell" // the only prototype cell in the table
        let myCell: UITableViewCell = listTableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

        if let myMatchCell = myCell as? MatchTableViewCell {
            let item = matches[indexPath.row]
            
            // this ensures that the upperLabel displays the winner and the lowerLabel displays the loser
            myMatchCell.upperLabel.text = item.p1Won ? item.p1Text : item.p2Text
            myMatchCell.lowerLabel.text = item.p1Won ? item.p2Text : item.p1Text
        }
        return myCell
    }
    
    // unused delegate methods
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) { }
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) { }
}
