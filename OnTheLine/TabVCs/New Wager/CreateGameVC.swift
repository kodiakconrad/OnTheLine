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
        datePicker.datePickerMode = .dateAndTime
        date.inputView = datePicker
        spread.keyboardType = .numberPad

        // Do any additional setup after loading the view.
    }
    
    func createGame()  -> Game {
        let away = awayTeam.text!
        let home = homeTeam.text!
        let title = "\(away) at \(home)"
        let time = date.date
        let spread = self.spread.text!
        let game = Game(name: title, homeTeam: home, awayTeam: away, time: time, spread: spread)
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
