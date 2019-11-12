//
//  RegisterMatchTableViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/11/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class RegisterMatchTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var players = [PlayerModel]()
    var locations = [String]()
    
    func reloadPlayerData() {
        let urlPath: String = Settings.urlStringPrefix + "currentstandingsjson.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
               
                var jsonResult = NSArray()
                                                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print(error)
                }
                
                var jsonElement = NSDictionary()
                var allPlayers = [PlayerModel]()
                
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
                        let player = PlayerModel(id: Int(id)!, name: name, points: Int(points)!, gamesPlayed: Int(gamesPlayed)!, gamesWon: Int(gamesWon)!, eros: Int(eros)!, matchesPlayed: Int(matchesPlayed)!, matchesWon: Int(matchesWon)!)
                        allPlayers.append(player)
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.players = allPlayers
                    self.player1Picker.reloadAllComponents()
                    self.player2Picker.reloadAllComponents()
                })
            }
        }
        task.resume()
    }
    
    func reloadLocationsData() {
        let urlPath: String = Settings.urlStringPrefix + "alllocationjson.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
               
                var jsonResult = NSArray()
                                                
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError {
                    print(error)
                }
                
                var jsonElement = NSDictionary()
                var allLocations = [String]()
                
                for i in 0 ..< jsonResult.count
                {
                    jsonElement = jsonResult[i] as! NSDictionary
                    
                    //the following insures none of the JsonElement values are nil through optional binding
                    if let name = jsonElement["location_name"] as? String
                    {
                        allLocations.append(name)
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.locations = allLocations
                    self.locationPicker.reloadAllComponents()
                })
            }
        }
        task.resume()
    }
        
    var urlString: String = Settings.urlStringPrefix + "currentstandingsjson.php"
    

    @IBOutlet weak var player1Picker: UIPickerView!
    @IBOutlet weak var player2Picker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    
    @IBOutlet weak var p1GamesToWin: UILabel!
    @IBOutlet weak var p1Points: UILabel!
    
    @IBOutlet weak var p1GamesWon: UILabel!
    @IBOutlet weak var p1EROs: UILabel!
    
    
    @IBOutlet weak var p2GamesToWin: UILabel!
    @IBOutlet weak var p2Points: UILabel!
    
    @IBOutlet weak var p2GamesWon: UILabel!
    @IBOutlet weak var p2EROs: UILabel!
    
    @IBOutlet weak var p1GamesToWinStepper: UIStepper!
    @IBOutlet weak var p1PointsStepper: UIStepper!
    @IBOutlet weak var p1GamesWonStepper: UIStepper!
    @IBOutlet weak var p1EROsStepper: UIStepper!
    
    @IBOutlet weak var p2GamesToWinStepper: UIStepper!
    @IBOutlet weak var p2PointsStepper: UIStepper!
    @IBOutlet weak var p2GamesWonStepper: UIStepper!
    @IBOutlet weak var p2EROsStepper: UIStepper!
    
    
    private func updateLabels() {
        p1GamesToWin.text = "Games to Win: \(Int(p1GamesToWinStepper.value))"
        p1Points.text = "Points Wagered: \(Int(p1PointsStepper.value))"
        p1GamesWon.text = "Games Won: \(Int(p1GamesWonStepper.value))"
        p1EROs.text = "EROs: \(Int(p1EROsStepper.value))"
        p2GamesToWin.text = "Games to Win: \(Int(p2GamesToWinStepper.value))"
        p2Points.text = "Points Wagered: \(Int(p2PointsStepper.value))"
        p2GamesWon.text = "Games Won: \(Int(p2GamesWonStepper.value))"
        p2EROs.text = "EROs: \(Int(p2EROsStepper.value))"
    }
    
    
    @IBAction func p1GamesToWinChanged(_ sender: UIStepper) {
        p1GamesWonStepper.maximumValue = sender.value
        p1EROsStepper.maximumValue = p1GamesWonStepper.value
        updateLabels()
    }
    
    @IBAction func p1PointsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    @IBAction func p1GamesWonChanged(_ sender: UIStepper) {
        p1EROsStepper.maximumValue = sender.value
        updateLabels()
    }
    @IBAction func p1EROsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    @IBAction func p2GamesToWinChanged(_ sender: UIStepper) {
        p2GamesWonStepper.maximumValue = sender.value
        p2EROsStepper.maximumValue = p2GamesWonStepper.value

        updateLabels()
    }
    
    @IBAction func p2PointsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    @IBAction func p2GamesWonChanged(_ sender: UIStepper) {
        p2EROsStepper.maximumValue = sender.value
        updateLabels()
    }
    
    @IBAction func p2EROsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    @IBAction func registerMatchButtonPressed(_ sender: UIButton) {
        registerMatch()
        
    }
    
    private func registerMatch() {
        let session = URLSession.shared
        let url = URL(string: Settings.urlStringPrefix + "registermatchjson.php")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        
        let json: [String: Any] = [
            "player1": players[player1Picker.selectedRow(inComponent: 0)].name,
            "player2": players[player2Picker.selectedRow(inComponent: 0)].name,
            "playerOneGamesInput": Int(p1GamesToWinStepper.value),
            "playerTwoGamesInput": Int(p2GamesToWinStepper.value),
            "playerOnePointsInput": Int(p1PointsStepper.value),
            "playerTwoPointsInput": Int(p2PointsStepper.value),
            "playerOneGamesWonInput": Int(p1GamesWonStepper.value),
            "playerTwoGamesWonInput": Int(p2GamesWonStepper.value),
            "locationPlayed": locations[locationPicker.selectedRow(inComponent: 0)]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        print(jsonData)

        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let tbc = self.tabBarController { tbc.selectedIndex = 0 }
            })
            
        }

        task.resume()
    }
    
    private func setUpSteppers() {
        p1GamesToWinStepper.maximumValue = 9
        p1GamesToWinStepper.minimumValue = 5
        p1GamesToWinStepper.autorepeat = false
        p1GamesToWinStepper.isContinuous = false
        p1GamesToWinStepper.value = 5
        
        p2GamesToWinStepper.maximumValue = 9
        p2GamesToWinStepper.minimumValue = 5
        p2GamesToWinStepper.autorepeat = false
        p2GamesToWinStepper.isContinuous = false
        p2GamesToWinStepper.value = 5
        
        p1PointsStepper.maximumValue = 25
        p1PointsStepper.minimumValue = 10
        p1PointsStepper.autorepeat = false
        p1PointsStepper.isContinuous = false
        p1PointsStepper.value = 10
        p1PointsStepper.stepValue = 5
        
        p2PointsStepper.maximumValue = 25
        p2PointsStepper.minimumValue = 10
        p2PointsStepper.autorepeat = false
        p2PointsStepper.isContinuous = false
        p2PointsStepper.value = 10
        p2PointsStepper.stepValue = 5
        
        p1GamesWonStepper.maximumValue = p1GamesToWinStepper.value
        p1GamesWonStepper.minimumValue = 0
        p1GamesWonStepper.autorepeat = false
        p1GamesWonStepper.isContinuous = false
        p1GamesWonStepper.value = 0
        
        p1EROsStepper.maximumValue = p1GamesWonStepper.value
        p1EROsStepper.minimumValue = 0
        p1EROsStepper.autorepeat = false
        p1EROsStepper.isContinuous = false
        p1EROsStepper.value = 0
        
        p2GamesWonStepper.maximumValue = p2GamesToWinStepper.value
        p2GamesWonStepper.minimumValue = 0
        p2GamesWonStepper.autorepeat = false
        p2GamesWonStepper.isContinuous = false
        p2GamesWonStepper.value = 0
        
        p2EROsStepper.maximumValue = p2GamesWonStepper.value
        p2EROsStepper.minimumValue = 0
        p2EROsStepper.autorepeat = false
        p2EROsStepper.isContinuous = false
        p2EROsStepper.value = 0

    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === player1Picker || pickerView === player2Picker { return players.count }
        else if pickerView === locationPicker { return locations.count }
        else { return 0 }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === player1Picker || pickerView === player2Picker { return players[row].name }
        else if pickerView === locationPicker { return locations[row] }
        else { return nil }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSteppers()
        
        player1Picker.delegate = self
        player1Picker.dataSource = self
        player2Picker.delegate = self
        player2Picker.dataSource = self
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        reloadPlayerData()
        reloadLocationsData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadPlayerData()
        reloadLocationsData()
    }
    
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
                                    
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        var allPlayers = [PlayerModel]()
        
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
                
                let player = PlayerModel(id: Int(id)!, name: name, points: Int(points)!, gamesPlayed: Int(gamesPlayed)!, gamesWon: Int(gamesWon)!, eros: Int(eros)!, matchesPlayed: Int(matchesPlayed)!, matchesWon: Int(matchesWon)!)

            
                
    //                location.name = name
    //                location.address = address
    //                location.latitude = latitude
    //                location.longitude = longitude
                
                allPlayers.append(player)

            }
            
            //print(player)
            
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.players = allPlayers
            self.player1Picker.reloadAllComponents()
            self.player2Picker.reloadAllComponents()

                
            })
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
