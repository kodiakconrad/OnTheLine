//
//  CreateGameVC.swift
//  
//
//  Created by Kodiak Conrad on 11/13/19.
//

import UIKit

class CreateGameVC: UIViewController {

    @IBOutlet weak var awayTeam: UITextField!
    @IBOutlet weak var homeTeam: UITextField!
    @IBOutlet weak var spread: UITextField!
    @IBOutlet weak var date: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(CreateGameVC.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateGameVC.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        date.inputView = datePicker
        spread.keyboardType = .numberPad

        // Do any additional setup after loading the view.
    }
    
    
    
    /*func createGame()  -> Game {
        let away = awayTeam.text!
        let home = homeTeam.text!
        let title = "\(away) at \(home)"
        //let time = date.date
        let spread = self.spread.text!
        //let game = Game(name: title, homeTeam: home, awayTeam: away, time: time, spread: spread)
    }*/
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormattter = DateFormatter()
        dateFormattter.dateFormat = "MM/dd/yyyy"
        date.text = dateFormattter.string(from: datePicker.date)
        view.endEditing(true)
        checkTextFields()
    }
    
    func checkTextFields() {
        if ((awayTeam.text?.isEmpty)! || (homeTeam.text?.isEmpty)! || (spread.text?.isEmpty)! || (date.text?.isEmpty)!){
            let alert = UIAlertController(title: "Missing text Fields", message: "please fill them out", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
        // need to do this for all
        } else {
            
            //not sure what im supposed to be doing here again
            //
            print("not empty")
        }
        sendDataToVc(myString: date.text!)
    }

    
    func sendDataToVc(myString : String) {
        let Vc = parent as! NewWagerVC
        Vc.dataFromContainer(containerData: myString)
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
