//
//  RegisterMatchTableViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/11/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// view controller for managing the Register Match tab
class RegisterMatchTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, DataRetrieverProtocol {
    
    /// the data retriever used to download the data
    private var dr: DataRetriever?
    /// the model for the playerPicker
    private var players = [PlayerModel]()
    /// the model for the locationPicker
    private var locations = [String]()
    /// the picker for choosing the players
    private var playerPicker: UIPickerView!
    /// the picker for choosing the location
    private var locationPicker: UIPickerView!
    /// the player chosen as player 1
    private var player1: PlayerModel?
    /// the player chosen as player 2
    private var player2: PlayerModel?
    /// the name of the location chosen
    private var location: String?
    /// text field for player 1
    @IBOutlet private weak var p1TextField: UITextField!
    /// text field for player 2
    @IBOutlet private weak var p2TextField: UITextField!
    /// text field for location
    @IBOutlet private weak var locationTextField: UITextField!
    /// label for player 1 games needed to win
    @IBOutlet private weak var p1GamesToWin: UILabel!
    /// label for points player 1 is wagering
    @IBOutlet private weak var p1Points: UILabel!
    /// label for the games that player 1 won
    @IBOutlet private weak var p1GamesWon: UILabel!
    /// label for player 1 eros
    @IBOutlet private weak var p1EROs: UILabel!
    /// label for player 1 games needed to win
    @IBOutlet private weak var p2GamesToWin: UILabel!
    /// label for points player 2 is wagering
    @IBOutlet private weak var p2Points: UILabel!
    /// label for the games that player 2 won
    @IBOutlet private weak var p2GamesWon: UILabel!
    /// label for player 2 eros
    @IBOutlet private weak var p2EROs: UILabel!
    /// stepper for player 1 games needed to win
    @IBOutlet private weak var p1GamesToWinStepper: UIStepper!
    /// stepper for player 1 points to wager
    @IBOutlet private weak var p1PointsStepper: UIStepper!
    /// stepper for player 1 games won
    @IBOutlet private weak var p1GamesWonStepper: UIStepper!
    /// stepper for player 1 eros
    @IBOutlet private weak var p1EROsStepper: UIStepper!
    /// stepper for player 2 games needed to win
    @IBOutlet private weak var p2GamesToWinStepper: UIStepper!
    /// stepper for player 2 points to wager
    @IBOutlet private weak var p2PointsStepper: UIStepper!
    /// stepper for player 2 games won
    @IBOutlet private weak var p2GamesWonStepper: UIStepper!
    /// stepper for player 2 eros
    @IBOutlet private weak var p2EROsStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new DataRetriever with self as the delegate
        dr = DataRetriever(withDelegate: self)
        
        // create the pickers
        playerPicker = UIPickerView()
        locationPicker = UIPickerView()
        
        // set up the steppers and their labels
        setUpSteppers()
        
        // assign the delegates for the pickers
        playerPicker.delegate = self
        playerPicker.dataSource = self
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        // set the inputs of the text fields to a picker (instead of keyboard)
        p1TextField.inputView = playerPicker
        p2TextField.inputView = playerPicker
        locationTextField.inputView = locationPicker
        
        // create a toolbar for the pickers (so 'done' can be chosen)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        // assign the toolbar to the pickers
        p1TextField.inputAccessoryView = toolBar
        p2TextField.inputAccessoryView = toolBar
        locationTextField.inputAccessoryView = toolBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        // download the initial data
        dr?.downloadPlayerData()
        dr?.downloadLocationData()
    }
    
    /// updates the labels to match the stepper values
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
    
    // MARK: - picker management
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === playerPicker { return players.count }
        else if pickerView === locationPicker { return locations.count }
        else { return 0 }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === playerPicker { return players[row].name }
        else if pickerView === locationPicker { return locations[row] }
        else { return nil }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // if its a player picker
        if pickerView === playerPicker {
            // if its player 1
            if p1TextField.isEditing {
                p1TextField.text = players[row].name
                player1 = players[row]
            }
            // if its player 2
            else if p2TextField.isEditing {
                p2TextField.text = players[row].name
                player2 = players[row]
            }
        }
        // else if its a location picker
        else if pickerView === locationPicker {
            if locationTextField.isEditing {
                locationTextField.text = locations[row]
                location = locations[row]
            }
        }
    }
    
    /// actions to be taken when the 'done' button in the picker toolbar is pressed, just resign the picker as firstResponder
    @objc func donePicker() {
        if p1TextField.isEditing { p1TextField.resignFirstResponder() }
        else if p2TextField.isEditing { p2TextField.resignFirstResponder() }
        else if locationTextField.isEditing { locationTextField.resignFirstResponder() }
    }
    
    // MARK: - stepper management
    
    /// called when the `p1GamesToWin` stepper is changed
    @IBAction private func p1GamesToWinChanged(_ sender: UIStepper) {
        // the games won cannot exceed the games needed to win
        p1GamesWonStepper.maximumValue = sender.value
        // the eros cannot exceed the games won
        p1EROsStepper.maximumValue = p1GamesWonStepper.value
        updateLabels()
    }
    
    /// called when the `p1PointsChanged` stepper is changed
    @IBAction private func p1PointsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    /// called when the `p1GamesWon` stepper is changed
    @IBAction private func p1GamesWonChanged(_ sender: UIStepper) {
        // the eros cannot exceed the games won
        p1EROsStepper.maximumValue = sender.value
        updateLabels()
    }
    
    /// called when the `p1EROs` stepper is changed
    @IBAction private func p1EROsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    /// called when the `p2GamesToWin` stepper is changed
    @IBAction private func p2GamesToWinChanged(_ sender: UIStepper) {
        // the games won cannot exceed the games needed to win
        p2GamesWonStepper.maximumValue = sender.value
        // the eros cannot exceed the games won
        p2EROsStepper.maximumValue = p2GamesWonStepper.value
        updateLabels()
    }
    
    /// called when the `p2Points` stepper is changed
    @IBAction private func p2PointsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    /// called when the `p2GamesWon` stepper is changed
    @IBAction private func p2GamesWonChanged(_ sender: UIStepper) {
        // the eros cannot exceed the games won
        p2EROsStepper.maximumValue = sender.value
        updateLabels()
    }
    
    /// called when the `p2EROs` stepper is changed
    @IBAction private func p2EROsChanged(_ sender: UIStepper) {
        updateLabels()
    }
    
    /// initializes the steppers to their default values
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
    
    // MARK: - register match
    
    /**
     action method called with the registerMatch button is pressed
     
     validates user input, sends alerts for problems with input. If there are no problems with input, call the `registerMatch()` function
     */
    @IBAction private func registerMatchButtonPressed(_ sender: UIButton) {
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
                preferredStyle: .alert
            )
            dualWinnerAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))
            present(dualWinnerAlert, animated: true, completion: nil)
        }
            
        // playing with yourself???
        else if player1 == player2 {
            let playingWithYourselfAlert = UIAlertController(
                title: "Playing With Yourself?",
                message: "With current input, it appears that you are playing against yourself. Please double check your input",
                preferredStyle: .alert
            )
            playingWithYourselfAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))
            present(playingWithYourselfAlert, animated: true, completion: nil)
        }
            
        // player 1 not chosen
        else if player1 == nil {
            let playingWithYourselfAlert = UIAlertController(
                title: "Player 1 Not Selected",
                message: "Choose a player as Player 1",
                preferredStyle: .alert
            )
            playingWithYourselfAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))
            present(playingWithYourselfAlert, animated: true, completion: nil)
        }
        
        // player 2 not chosen
        else if player2 == nil {
            let playingWithYourselfAlert = UIAlertController(
                title: "Player 2 Not Selected",
                message: "Choose a player as Player 2",
                preferredStyle: .alert
            )
            playingWithYourselfAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))
            present(playingWithYourselfAlert, animated: true, completion: nil)
        }
            
        // location not chosen
        else if location == nil {
            let playingWithYourselfAlert = UIAlertController(
                title: "Location Not Selected",
                message: "Choose the location where the match was played",
                preferredStyle: .alert
            )
            playingWithYourselfAlert.addAction(UIAlertAction(
                title: "OK",
                style: .cancel
            ))
            present(playingWithYourselfAlert, animated: true, completion: nil)
        }
            
        // valid data, go ahead and register the match
        else { registerMatch() }
    }
    
    /**
       Registers a match
       
       Creates a urlsession, creats a json dictionary, creates a http POST request, and sends the request
    */
    private func registerMatch() {
        let session = URLSession.shared
        let url = URL(string: Settings.urlStringPrefix + "registermatchjson.php")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // setup the request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // create the json dictionary
        let json: [String: Any] = [
          "player1": player1?.name ?? "Error",
          "player2": player2?.name ?? "Error",
          "playerOneGamesInput": Int(p1GamesToWinStepper.value),
          "playerTwoGamesInput": Int(p2GamesToWinStepper.value),
          "playerOnePointsInput": Int(p1PointsStepper.value),
          "playerTwoPointsInput": Int(p2PointsStepper.value),
          "playerOneGamesWonInput": Int(p1GamesWonStepper.value),
          "playerTwoGamesWonInput": Int(p2GamesWonStepper.value),
          "locationPlayed": locations[locationPicker.selectedRow(inComponent: 0)],
          "playerOneERO": Int(p1EROsStepper.value),
          "playerTwoERO": Int(p2EROsStepper.value)  ]

        // serialize the data
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        // send the request
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            // upon completion change the current view to the Match History tab
            DispatchQueue.main.async(execute: { () -> Void in
              if let tbc = self.tabBarController { tbc.selectedIndex = 0 }
            })
        }
        task.resume()
    }
    
    // MARK: - delegate methods for DataRetrieverProtocol
    
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {
        self.players = playerData
        
        // sort the players by alphabetical order of name
        players.sort() { $0.name < $1.name }
        playerPicker.reloadAllComponents()
    }
    
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) {
        self.locations = locationNameData
        
        // sort the location names by alphabetical order
        locations.sort() { $0 < $1 }
        locationPicker.reloadAllComponents()
    }
    
    // unused delegates from DataRetriever
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) { }
}
