//
//  NewWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit

class NewWagerVC: TabViewController, CreateGameDelegate {

    var event: Event? = nil
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var wagerTypeControl: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    
    var gameContainer: CreateGameVC?
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gameContainer?.delegate = self
        //print(gameDate.debugDescription)

    }
    
    func dummyFunction(sentGame: Game) {
        print("dummy-funciton")
        event = sentGame
    }
    
    func dummyFunction(withParameter param: String) {
        print("dummy-function-\(param)")
    }

    @IBAction func pressedCreate(_ sender: Any) {
        switch wagerTypeControl.selectedSegmentIndex {
        case 0: // game
            print("game")
            
            //gameContainer
        case 1: // stat
            print("stat")
        case 2: // event
            print("event")
        default:
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
    
    func dataFromContainer(containerData : String){
        print(containerData)
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
