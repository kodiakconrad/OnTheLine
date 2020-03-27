//
//  NewWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

// INTERN

import UIKit

class NewWagerVC: TabViewController {

    var event: Event? = nil
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var wagerTypeControl: UISegmentedControl!
    
    var gameContainer: CreateGameVC?
    gameContainer?.delegate = self
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    func dummyFunction(sentGame: Game) {
        print("dummy-funciton")
        event = sentGame
        print(event?.choiceA ?? "no value")
    }
    
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let 
            //gameView.alpha = 1
            //statView.alpha = 0
            //eventView.alpha = 0
            //print(gameDate.debugDescription)
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
}
