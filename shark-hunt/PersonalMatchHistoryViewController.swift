//
//  PersonalMatchHistoryViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/17/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class PersonalMatchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataRetrieverProtocol {
    
    @IBOutlet weak var listTableView: UITableView!
    
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) {
        matches = matchHistoryData
        
        matches = matches.filter {
            $0.p1Name == player.name || $0.p2Name == player.name
        }
        
        listTableView.reloadData()
        
        print(matches.count)
        
        //print("upateMatchHistory from data retriever")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicMatchHistoryCell"
        let myCell: UITableViewCell = listTableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

        if let myMatchCell = myCell as? MatchTableViewCell {
           let item = matches[indexPath.row]
           
            print(item.p1Name)
            
           myMatchCell.upperLabel.text = item.upperText
           myMatchCell.lowerLabel.text = item.lowerText
        }
        return myCell
    }
    
    
    var player: PlayerModel!
    var matches = [MatchModel]()
    
    var dr: DataRetriever?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dr = DataRetriever(withDelegate: self)
        listTableView.delegate = self
        listTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dr?.downloadPersonalMatchHistory(withPlayerID: player.id)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {
        
    }
    
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) {
        
    }

}
