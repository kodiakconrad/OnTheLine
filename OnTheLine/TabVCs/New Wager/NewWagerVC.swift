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
    var friendData: [[String: String]]? = []
    var numFriends = 0
    var opponentUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFriends()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.searchedName.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numFriends
    }
    
    // set rows based on class properties
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "friendo")
        if (friendData?.isEmpty)! {
            cell.textLabel?.text = "No users found"
        } else {
            let row = (indexPath[1])
            let uname = friendData?[row]["username"]
            cell.textLabel?.text = friendData?[row]["name"]
            cell.detailTextLabel?.text = uname
            cell.imageView?.image = UIImage.init(named: "first")
            cell.addGestureRecognizer(OpponentTapGestureRecognizer.init(target: self, action: #selector(tappedRow(sender:)), username: uname!))
        }
    
        return cell
    }
    
    // push event type VC with opponent info when their name is tapped
    @objc func tappedRow(sender: OpponentTapGestureRecognizer) {
        print("in tappedRow")
        let userRef = db.collection("Usernames").document(sender.opponentUsername!)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let friendUid = document.data()!["uid"] as! String
                self.opponentUID = friendUid
            } else {
                //do some error handling
                print("doc does not exist")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newWagerVC = storyboard.instantiateViewController(withIdentifier: "eventType") as! EventTypeVC
            newWagerVC.opponent = self.opponentUID
            self.navigationController?.pushViewController(newWagerVC, animated: true)
        }
    }

    
    //initial call to populate friends table
    func getFriends() {
        let friendsRef = db.collection("Users").document(self.uid).collection("friends").whereField("status", isEqualTo: "active")
        friendsRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let mySet = ["name", "username"]
                    let name = document.data().filter({mySet.contains($0.key)}) as! [String : String]
                    if ((self.friendData?.contains(name))!) {
                        // do nothing
                    } else {
                        self.numFriends += 1
                        self.friendData?.append(name)
                    }
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

//custom gesture recognizer that includes username where it came from
class OpponentTapGestureRecognizer: UITapGestureRecognizer {
    var opponentUsername : String?
    
    init(target: Any?, action: Selector?, username: String) {
        super.init(target: target, action: action)
        opponentUsername = username
    }
}

// for presenting new game VC
/*
 
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 let newGameVC = storyboard.instantiateViewController(withIdentifier: "newGame") as! CreateGameVC
 newGameVC.view.frame = CGRect()
 self.present(newGameVC, animated: true, completion: nil)
 
 */
