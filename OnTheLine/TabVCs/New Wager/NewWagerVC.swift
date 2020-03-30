//
//  NewWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

// INTERN

import UIKit

class NewWagerVC: TabViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var searchedName: UITextField!
    var event: Event? = nil
    var numUsers = 10
    
    var gameContainer: CreateGameVC?
    //gameContainer?.delegate = self
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.searchedName.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath)
        return cel
    }
    
    func dummyFunction(sentGame: Game) {
        print("dummy-funciton")
        event = sentGame
        print(event?.choiceA ?? "no value")
    }
}

class friendCell {
    
}

// for presenting new game VC
/*
 
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 let newGameVC = storyboard.instantiateViewController(withIdentifier: "newGame") as! CreateGameVC
 newGameVC.view.frame = CGRect()
 self.present(newGameVC, animated: true, completion: nil)
 
 */
