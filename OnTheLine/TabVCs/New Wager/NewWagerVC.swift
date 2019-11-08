//
//  NewWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit

class NewWagerVC: TabViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var wagerTypeControl: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var gameAway: UITextField!
    @IBOutlet weak var gameHome: UITextField!
    @IBOutlet weak var gameSpread: UITextField!
    @IBOutlet weak var gameDate: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        print("hiiiiiiiiiiiiiiiiiiiiiii")
        //print(gameDate.debugDescription)
        //gameDate.inputView = datePicker
    }
    

    @IBAction func pressedCreate(_ sender: Any) {
        switch wagerTypeControl.selectedSegmentIndex {
        case 0: // game
            let away = gameAway.text!
            let home = gameHome.text!
            let name = "\(away) at \(home)"
            
            let spread = gameSpread.text!
            //let wager = Game(name: <#T##String#>, homeTeam: <#T##String#>, awayTeam: <#T##String#>, time: <#T##Date#>, spread: <#T##Double#>)
        case 1: // stat
            print("stat")
        case 2: // event
            print("event")
        default:
            print("default")
            break
        }
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gameView.alpha = 1
            statView.alpha = 0
            eventView.alpha = 0
        case 1:
            statView.alpha = 1
            gameView.alpha = 0
            eventView.alpha = 0
        case 2:
            eventView.alpha = 1
            gameView.alpha = 0
            statView.alpha = 0
        default:
            break;
        }
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
