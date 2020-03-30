//
//  NewWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

// INTERN

import UIKit
import Firebase

class NewWagerVC: TabViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var searchedName: UITextField!
    var event: Event? = nil
    var numFriends = 0
    
    var gameContainer: CreateGameVC?
    //gameContainer?.delegate = self
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getFriends()
        self.searchedName.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numFriends
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "friendo")
        cell.textLabel?.text = "friend"
        cell.detailTextLabel?.text = "username"
        cell.imageView?.image = UIImage.init(named: "first")
        return cell
    }
    
    func getFriends() {
        let friendsRef = db.collection("Users").document(self.uid).collection("friends")
        friendsRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.numFriends += 1
                    print("\(document.documentID) => \(document.data())")
                    self.friendTable.reloadData()
                }
            }
        }
    }
    func dummyFunction(sentGame: Game) {
        print("dummy-funciton")
        event = sentGame
        print(event?.choiceA ?? "no value")
    }
}


// for presenting new game VC
/*
 
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 let newGameVC = storyboard.instantiateViewController(withIdentifier: "newGame") as! CreateGameVC
 newGameVC.view.frame = CGRect()
 self.present(newGameVC, animated: true, completion: nil)
 
 */
