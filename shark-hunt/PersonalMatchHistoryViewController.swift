//
//  PersonalMatchHistoryViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/17/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for displaying the personal match history of a player
class PersonalMatchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataRetrieverProtocol {
    
    private var player: PlayerModel!
    private var matches = [MatchModel]()
    private var dr: DataRetriever?
    
    @IBOutlet private weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dr = DataRetriever(withDelegate: self)
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // start the process of downloading match history data, result of the download will be passed with delegate call to updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData)
        dr?.downloadMatchHistory()
    }
    
    /**
     delegate method of DataRetriever, sends the requested data to the delegate
     
     - Parameter matchHistoryData: the array of MatchModels downloaded by the dataRetriever
     */
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) {
        //filter the matches to only those with the player involved
        matches = matchHistoryData.filter { $0.p1Name == player.name || $0.p2Name == player.name }
        listTableView.reloadData()
    }
    
    /**
     delegate method of UITableView, called when the table view needs to know how many rows belong in the specficied section
     
     - Parameter tableView: the table view of interest
     - Parameter section: the section of interest in the tableView
    
     - Returns: the number of rows that belong in the section of the tableView
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    /**
     delegate method of UITableView, called when the tableView needs a cell to display in the tableView
     
     - Parameter tableView: the table view of interest
     - Parameter indexPath: the indexPath of the tableView for which we need to supply a tableViewCell
     
     - Returns: the UITableViewCell to be displayed for the specified indexPath
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicMatchHistoryCell" // the only prototype cell in the table
        let myCell: UITableViewCell = listTableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

        if let myMatchCell = myCell as? MatchTableViewCell {
            let item = matches[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = Locale(identifier: "en_US")
            
            myMatchCell.dateAndTimeLabel.text = dateFormatter.string(from: item.dateAndTime)
            
            // this makes sure the winning player is displayed in the upper label
            myMatchCell.winningPlayerLabel.text = item.p1Won ? item.p1Text : item.p2Text
            myMatchCell.losingPlayerLabel.text = item.p1Won ? item.p2Text : item.p1Text
        }
        return myCell
    }
    
    /**
     should be called in the segueing VC to prepare this VC (by providing the Player for which we will be displaying match history for)
     
     - Parameter player: the player for which we will be providing match history for
     */
    func prepareForBeingSeguedTo(withPlayer player: PlayerModel) {
        self.player = player
    }
    
    // unused DataRetriever delegate methods
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) { }
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) { }
}
