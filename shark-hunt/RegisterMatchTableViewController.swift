//
//  RegisterMatchTableViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/11/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

class RegisterMatchTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, DataRetrieverProtocol {
    
    var dr: DataRetriever?
    var players = [PlayerModel]()
    var locations = [String]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dr = DataRetriever(withDelegate: self)
        
        setUpSteppers()
        player1Picker.delegate = self
        player1Picker.dataSource = self
        player2Picker.delegate = self
        player2Picker.dataSource = self
        locationPicker.delegate = self
        locationPicker.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dr?.downloadPlayerData()
        dr?.downloadLocationData()
    }
    
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {
        self.players = playerData
        players.sort() { $0.name < $1.name }
        player1Picker.reloadAllComponents()
        player2Picker.reloadAllComponents()
    }
    
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) {
        self.locations = locationNameData
        locations.sort() { $0 < $1 }
        locationPicker.reloadAllComponents()
    }

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
            "locationPlayed": locations[locationPicker.selectedRow(inComponent: 0)],
            "playerOneERO": Int(p1EROsStepper.value),
            "playerTwoERO": Int(p2EROsStepper.value)  ]
        
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
        // nobody won???
        if p1GamesWonStepper.value != p1GamesToWinStepper.value && p2GamesWonStepper.value != p2GamesToWinStepper.value {
            let noWinnerAlert = UIAlertController(
                title: "No Winner Selected",
                message: "With current input, there is no winner of this match. Please double check your input",
                preferredStyle: .alert)
            
            noWinnerAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))
            
            present(noWinnerAlert, animated: true, completion: nil)
        }
        // both players won???
        else if p1GamesWonStepper.value == p1GamesToWinStepper.value && p2GamesWonStepper.value == p2GamesToWinStepper.value {
            let dualWinnerAlert = UIAlertController(
                title: "Two Winners Selected",
                message: "With current input, there appears to be two winners of this match. Please double check your input",
                preferredStyle: .alert)
            
            dualWinnerAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))

            present(dualWinnerAlert, animated: true, completion: nil)
        }
        // playing with yourself???
        else if player1Picker.selectedRow(inComponent: 0) == player2Picker.selectedRow(inComponent: 0) {
            let playingWithYourselfAlert = UIAlertController(
                title: "Playing With Yourself?",
                message: "With current input, it appears that you are playing against yourself. Please double check your input",
                preferredStyle: .alert)
            
            playingWithYourselfAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))

            present(playingWithYourselfAlert, animated: true, completion: nil)
        }
        // valid data, go ahead and register the match
        else {
            registerMatch()
        }
    }
    
    // unused
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) { }
}
