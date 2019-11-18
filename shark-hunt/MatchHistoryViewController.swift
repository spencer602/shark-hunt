//
//  MatchHistoryViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// a class for displaying the match history with a TableView in a ViewController
class MatchHistoryViewController: UIViewController, DataRetrieverProtocol, UITableViewDelegate, UITableViewDataSource {
    
    /// the DataRetriver object that will be used to download data
    private var dr: DataRetriever?
    
    /// the array of MatchModels that will be used as the model for the TableView
    private var matches = [MatchModel]()
    
    /// the table view we are using
    @IBOutlet private weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the delegates for the UITableView
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        //creating our DataRetriever and setting self as the delegate
        dr = DataRetriever(withDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dr?.downloadMatchHistory()  // download the data for the first time
    }
    
    // MARK: - TableView data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicMatchHistoryCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        if let myMatchCell = myCell as? MatchTableViewCell {
            let item = matches[indexPath.row]
            
            // this makes sure the winning player is displayed in the upper label
            myMatchCell.upperLabel.text = item.p1Won ? item.p1Text : item.p2Text
            myMatchCell.lowerLabel.text = item.p1Won ? item.p2Text : item.p1Text
        }
        return myCell
    }
    
    // MARK: - DataRetrieverProtocol methods
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) {
           matches = matchHistoryData
           listTableView.reloadData()  // update the table view with the (possibly) updated data
       }
    
    // unused delegate methods for DataRetriever
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {}
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) {}
}
