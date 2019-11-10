//
//  ViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/7/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataRetrieverProtocol  {
    
    var feedItems = [PlayerModel]()
    var selectedPerson = PlayerModel()

    func itemsDownloaded(items: [PlayerModel]) {
        feedItems = items
        self.listTableView.reloadData()
    }
    

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        var dr = DataRetriever()
        dr.downloadItems()
        dr.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
    // Retrieve cell
    let cellIdentifier: String = "BasicCell"
    let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
    // Get the location to be shown
    let item = feedItems[indexPath.row]
    // Get references to labels of cell
    myCell.textLabel!.text = item.name

    return myCell
   }


}

