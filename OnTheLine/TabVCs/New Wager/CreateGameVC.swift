//
//  CreateGameVC.swift
//  
//
//  Created by Kodiak Conrad on 11/13/19.
//

// BOSS

import UIKit
import Foundation

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
        spread.keyboardType = .numberPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         return Double(string) != nil
    }
    
    func createGame()  -> Game {
        checkTextFields()
        let away = awayTeam.text!
        let home = homeTeam.text!
        let title = "\(away) at \(home)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let time = dateFormatter.date(from: date.text!)
        let spread = Double(self.spread.text!)
        let game = Game(name: title, homeTeam: home, awayTeam: away, time: time!, spread: spread!)
        return game
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
    @IBAction func pressedCreate(_ sender: Any) {
        checkTextFields()
        let game = createGame()
        game.toString()
        // now time to actually update database 
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkTextFields() {
        if ((awayTeam.text?.isEmpty)! || (homeTeam.text?.isEmpty)! || (spread.text?.isEmpty)! || (date.text?.isEmpty)!) || (wagerValue.text?.isEmpty)! { // still need to check values are correct type
            let alert = UIAlertController(title: "Missing text Fields", message: "please fill them out", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            print("good to go")
        }
    }
    
}
