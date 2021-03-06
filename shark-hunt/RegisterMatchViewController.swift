//
//  RegisterMatchViewController.swift
//  shark-hunt
//
//  Created by Spencer DeBuf on 11/11/19.
//  Copyright © 2019 Spencer DeBuf. All rights reserved.
//

import UIKit

/// deprecated, RegisterMatchTableViewController is used instead
class RegisterMatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, DataRetrieverProtocol {
    
    var dr: DataRetriever?
    var players = [PlayerModel]()
    
    @IBOutlet weak var p1Picker: UIPickerView!
    @IBOutlet weak var p2Picker: UIPickerView!

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

        p1Picker.delegate = self
        p1Picker.dataSource = self

        p2Picker.delegate = self
        p2Picker.dataSource = self
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dr?.downloadPlayerData()
        dr?.downloadLocationData()
    }
    
    func updatePlayerDataFromDataRetriever(withPlayerData playerData: [PlayerModel]) {
        
    }
    
    func updateMatchHistoryDataFromDataRetriever(withMatchHistoryData matchHistoryData: [MatchModel]) {
        
    }
    
    func updateLocationNameDataFromDataRetriever(withLocationNameData locationNameData: [String]) {
        
    }
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return players[row].name;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
   
    
    
    private func updateLabels() {
        p1GamesToWin.text = "Games to Win: \(Int(p1GamesToWinStepper.value))"
        p1Points.text = "Points to Wager: \(Int(p1PointsStepper.value))"
        p1GamesWon.text = "Games Won: \(Int(p1GamesWonStepper.value))"
        p1EROs.text = "EROs: \(Int(p1EROsStepper.value))"
        p2GamesToWin.text = "Games to Win: \(Int(p2GamesToWinStepper.value))"
        p2Points.text = "Points to Wager: \(Int(p2PointsStepper.value))"
        p2GamesWon.text = "Games Won: \(Int(p2GamesWonStepper.value))"
        p2EROs.text = "EROs: \(Int(p2EROsStepper.value))"
    }
    
    
    @IBAction func p1GamesToWinChanged(_ sender: UIStepper) {
        p1GamesWonStepper.maximumValue = sender.value
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
        if let tbc = tabBarController {
            tbc.selectedIndex = 0
        }
    }
    
    private func registerMatch() {
        let session = URLSession.shared
        let url = URL(string: Settings.urlStringPrefix + "registermatchjson.php")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        
        let json: [String: Any] = [
            "player1": players[p1Picker.selectedRow(inComponent: 0)].name,
            "player2": players[p2Picker.selectedRow(inComponent: 0)].name,
            "playerOneGamesInput": Int(p1GamesToWinStepper.value),
            "playerTwoGamesInput": Int(p2GamesToWinStepper.value),
            "playerOnePointsInput": Int(p1PointsStepper.value),
            "playerTwoPointsInput": Int(p2PointsStepper.value),
            "playerOneGamesWonInput": Int(p1GamesWonStepper.value),
            "playerTwoGamesWonInput": Int(p2GamesWonStepper.value)
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        print(jsonData)

        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
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
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return players.count
    }

    
    
    func appleTestRun() {
        
        struct Order: Codable {
            let customerId: String
            let items: [String]
        }

        // ...

        let order = Order(customerId: "12345",
                          items: ["Cheese pizza", "Diet soda"])
        guard let uploadData = try? JSONEncoder().encode(order) else {
            print("error in JSONE enconder")
            return
        }
        
        let url = URL(string: Settings.urlStringPrefix + "registermatchjson.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }
        task.resume()
        
        
    }
    
    func runTestPostRequest() {
        let session = URLSession.shared
        let url = URL(string: Settings.urlStringPrefix + "registermatchjson.php")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
        
        let json = [
            "player1": "Spencer DeBuf",
            "player2": "Spencer DeBuf"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        print(jsonData)

        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }

        task.resume()
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
