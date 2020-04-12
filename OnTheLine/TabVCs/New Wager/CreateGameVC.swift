//
//  CreateGameVC.swift
//  
//
//  Created by Kodiak Conrad on 11/13/19.
//

// BOSS

import UIKit
import Foundation
import Firebase

class CreateGameVC: EventTypeVC, UITextFieldDelegate {

    @IBOutlet weak var awayTeam: UITextField!
    @IBOutlet weak var homeTeam: UITextField!
    @IBOutlet weak var spread: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var wagerValue: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spread.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(CreateGameVC.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateGameVC.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        date.inputView = datePicker
        spread.keyboardType = .numbersAndPunctuation
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         return Double(string) != nil
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }

    func checkTextFields() {
        if ((awayTeam.text?.isEmpty)! || (homeTeam.text?.isEmpty)! || (spread.text?.isEmpty)! || (date.text?.isEmpty)!) || (wagerValue.text?.isEmpty)! {
            // still need to check values are correct type
            let alert = UIAlertController(title: "Missing text Fields", message: "please fill them out", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            print("good to go")
        }
    }
    
    func createGame() -> Game {
        checkTextFields()
        let away = awayTeam.text!
        let home = homeTeam.text!
        let title = "\(away) at \(home)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let time = dateFormatter.date(from: date.text!)
        let spread = Double(self.spread.text!)
        let game = Game(name: title, homeTeam: home, awayTeam: away, timestamp: time!, spread: spread!)
        game.toString()
        return game
    }
    
    // adds event to "Events" collection and returns eventID
    func addGametoDatabase(game: Game, completion: (_ docID: String) -> Void) {
        let docRef = db.collection(EVENTS).document()
        docRef.setData(game.getData()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef.documentID)")
            }
        }
        
        completion(docRef.documentID)
    }
    
    // add wager to collection "Wagers" and returns wagerID
    func addWagertoDatabbase(eventID: String, completion: (_ wagerID: String) -> Void) {
        let wagerRef = db.collection(WAGERS).document()
        var data = [String: Any]()
        data["Event"] = eventID
        data["Status"] = "pending"
        data["Value"] = self.wagerValue.text!
        data["uid1"] = self.uid
        data["uid2"] = self.opponent
        wagerRef.setData(data)  { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(wagerRef.documentID)")
            }
        }
        completion(wagerRef.documentID)
    }
    
    func addtoLedger(wagerID: String) {
        let userRef = db.collection(LEDGER).document(self.uid)
        print("\(LEDGER) and \(self.uid)")
        userRef.updateData([
            "Pending": FieldValue.arrayUnion([wagerID])
                ])

        
        let oppRef = db.collection(LEDGER).document(self.opponent)
        oppRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var pending = data?["Pending"] as! Array<String>
                pending.append(wagerID)
            } else {
                print("error, opponent user was somehow not added to ledger beforehand")
            }
        }
    }
    
    @IBAction func pressedCreate(_ sender: Any) {
        checkTextFields()
        let game = createGame()
        addGametoDatabase(game: game) { //add event to database
            (docID: String) in
            addWagertoDatabbase(eventID: docID) { // add wager
                (wagerID: String) in
                addtoLedger(wagerID: wagerID) // add to ledger
            }
            print("finished all database manipulataion")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

//For later
//
//
//
//

    func updateWagers(completion: (String) -> Void) {
        let WagersRef = db.collection(WAGERS)
        let mydata = ["": ""]
        WagersRef.addDocument(data: mydata)
        let wagerID = "wagerID"
        completion(wagerID)
    }

    func updateLedger() {
        
    }
}
