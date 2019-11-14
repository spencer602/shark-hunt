//
//  MatchHistoryViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/10/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class MatchHistoryViewController: UIViewController, DataRetrieverProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var dr: DataRetriever?
    var matches = [MatchModel]()
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        dr = DataRetriever(withDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dr?.downloadMatchHistory()
    }
    
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) {
        matches = matchHistoryData
        listTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicMatchHistoryCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        if let myMatchCell = myCell as? MatchTableViewCell {
            let item = matches[indexPath.row]
            
            myMatchCell.upperLabel.text = item.upperText
            myMatchCell.lowerLabel.text = item.lowerText
        }
        return myCell
    }
    
    // unused
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {}
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) {}
}
