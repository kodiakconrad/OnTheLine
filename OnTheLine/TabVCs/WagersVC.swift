//
//  WagersVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit

class WagersVC: TabViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var wagersTableView: UITableView!
    var cellCounts = [0,0,0]
    var headers = ["Pending", "Active", "Completed"]
    var active = [String]()
    var pending = [String]()
    var completed = [String]()
    var tableData = [[Wager]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveWagerIDs() {
            //print("retrieved wagers")
            self.cellCounts[0] = self.pending.count
            self.cellCounts[1] = self.active.count
            self.cellCounts[2] = self.completed.count
            self.collectWagerData {
                self.wagersTableView.reloadData()
            }
        }
    }
    
    // get the three lists of wagerIDs from the "Ledger"
    // collection
    func retrieveWagerIDs(completion: @escaping () -> Void) {
        let userRef = db.collection("Ledger").document(self.uid)
        userRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.active = data?["Active"] as! [String]
                self.pending = data?["Pending"] as! [String]
                self.completed = data?["Completed"] as! [String]
            } else {
                completion()
                print("error, cant find user in ledger")
                //do error handling later
            }
        completion()
        }
    }
    
    // iterates through all wagerIDs and gets events and users
    func collectWagerData(completion: @escaping () -> Void) {
        if self.pending.count != 0 {
            for wagerID in self.pending {
                self.getWager(wagerID: wagerID, type: "Pending")
            }
        }
        if self.active.count != 0 {
            for wagerID in self.active {
                self.getWager(wagerID: wagerID, type: "Active")
            }
        }
        if self.completed.count != 0 {
            for wagerID in self.completed {
                self.getWager(wagerID: wagerID, type: "Completed")
            }
        }
        completion()
    }
    
    
    func getWager(wagerID: String, type: String) {
        let ref = db.collection("Wagers").document(wagerID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let uid1 = data["uid1"]
                let uid2 = data["uid2"]
                let value = data["Value"]
                let eventID = data["Event"] //change to "eventID"
                self.populateDataTable(uid1: uid1! as! String, uid2: uid2! as! String, eventid: eventID! as! String) {
                    user1, user2, event in
                    let wager = Wager.init(type: EventType.game, event: event)
                    wager.users = [user1, user2]
                    wager.value = value as! Int
                    switch type {
                        case "Pending":
                        self.tableData[0].append(wager)
                        case "Active":
                        self.tableData[1].append(wager)
                        case "Completed":
                        self.tableData[2].append(wager)
                        default:
                        // something went wrong
                        break
                    }
                }
            } else {
                print("no wager with ID \(wagerID)")
                // do error handling
            }
        }
    }
    
    func populateDataTable(uid1: String, uid2: String, eventid: String, completion: (_ user1: String, _ user2: String, _ event: Event) -> Void) {
        // Remember: UID1 is home team. UID2 is away team
        let eventRef = db.collection("Events").document(eventid)
        let userRef = db.collection("Users")
        var user1 = ""
        var user2 = ""
        var event: Event? = nil
        eventRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let eventData = document.data()!
                let eventType = eventData["EventType"]! as! String
                if eventType == "Game" {
                    event = Game.init(data: eventData)
                } else if eventType == "Statistic" {
                    // TODO
                } else {
                    // TODO
                }
            } else {
                print("Event does not exist")
                // do error handling
            }
        }
        userRef.document(uid1).getDocument { (document, error) in
            if let document = document, document.exists {
                user1 = document.data()!["username"] as! String
            } else {
                print("UID1 does not exist")
                // do error handling
            }
        }
        userRef.document(uid2).getDocument { (document, error) in
            if let document = document, document.exists {
                user2 = document.data()!["username"] as! String
            } else {
                print("UID2 does not exist")
                // do error handling
            }
        }
        guard (user1 != "" && user2 != "" && event != nil) else {
            // do error handling
            // throw error about event
            print("did not guard event enough")
            return
        }
        completion(user1, user2, event!)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCounts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeCell", for: indexPath) as! GameTableViewCell
        print(indexPath.section)
        print(indexPath.row)
        let cellData = tableData[indexPath.section][indexPath.row]
        let event = cellData.event
        switch cellData.type {
            case .game:
            print("case game")
            cell.away.text = event.awayTeam
            cell.home.text = event.homeTeam
            print(event.timestamp!)
            cell.date.text = event.timestamp.toString(dateFormat: "MM/dd/yyyy")
            cell.spread.text = String(event.spread)
            cell.value.text = String(cellData.value)
            cell.user1.text = cellData.users[0]
            cell.user2.text = cellData.users[1]
            case .statistic:
            print("case statistic")
            case .outcome:
            print("case outcome")
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}

class GameTableViewCell: UITableViewCell{
    @IBOutlet weak var away: UILabel!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var spread: UILabel!
    @IBOutlet weak var user1: UILabel!
    @IBOutlet weak var user2: UILabel!
    @IBOutlet weak var value: UILabel!
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
