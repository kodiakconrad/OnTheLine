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
            self.collectWagerData {
                print("wager data collected")
                self.cellCounts[0] = self.pending.count
                self.cellCounts[1] = self.active.count
                self.cellCounts[2] = self.completed.count
                self.wagersTableView.reloadData()
            }
        }
    }
    
    // get the three lists of wagerIDs from the "Ledger"
    // collection
    func retrieveWagerIDs(completion: @escaping () -> Void) {
        let userRef = db.collection(LEDGER).document(self.uid)
        print(userRef.path)
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
            print("completed collecting wager ID")
            completion()
        }
    }
    
    // iterates through all wagerIDs and gets events and users
    func collectWagerData(completion: @escaping () -> Void) {
        print("collecting wager data")
        let myGroup = DispatchGroup()
        if self.pending.count != 0 {
            myGroup.enter()
            for wagerID in self.pending {
                self.getWager(wagerID: wagerID, type: "Pending") {
                    myGroup.leave()
                }
            }
  
        }
        if self.active.count != 0 {
            myGroup.enter()
            for wagerID in self.active {
                self.getWager(wagerID: wagerID, type: "Active") {
                    myGroup.leave()
                }

            }

        }
        if self.completed.count != 0 {
            myGroup.enter()
            for wagerID in self.completed {
                self.getWager(wagerID: wagerID, type: "Completed") {
                    myGroup.leave()
                }
            }
        }
        print("waiting for dispatch group")
        myGroup.notify(queue: .main) {
            print("completion")
            completion()
        }

    }
    
    func getWager(wagerID: String, type: String, completion: @escaping () -> Void) {
        print("get wager called")
        let wagerRef = db.collection(WAGERS).document(wagerID)
        wagerRef.getDocument() {
            (document, error) in
            print("in body of getdoc")
            if error != nil {
                print("error in getWager")
                print(error.debugDescription)
            }
            if let document = document, document.exists {
                let data = document.data()!
                print(data)
                let uid1 = data["uid1"] as! String
                let uid2 = data["uid2"] as! String
                let value = data["Value"]
                let eventID = data["Event"] //change to "eventID"
                print("populating data table")
                // Remember: UID1 is home team. UID2 is away team
                let eventRef = self.db.collection(self.EVENTS).document(eventID! as! String)
                let userRef = self.db.collection(self.USERS)
                var user1 = ""
                var user2 = ""
                var event: Event? = nil
                let dp = DispatchGroup()
                dp.enter()
                eventRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let eventData = document.data()!
                        print(eventData)
                        let eventType = eventData["EventType"]! as! String
                        if eventType == "Game" {
                            event = Game.init(data: eventData)
                        } else if eventType == "Statistic" {
                            // TODO
                            event = Statistic.init(name: "temp", subject: "temp", statType: "temp", value: 0)
                        } else {
                            // TODO
                        }
                    } else {
                        print("Event does not exist")
                        // do error handling
                    }
                    dp.leave()
                }
                dp.enter()
                userRef.document(uid1).getDocument { (document, error) in
                    if let document = document, document.exists {
                        user1 = document.data()!["username"] as! String
                    } else {
                        print("UID1 does not exist")
                        // do error handling
                    }
                    dp.leave()
                }
                dp.enter()
                userRef.document(uid2).getDocument { (document, error) in
                    if let document = document, document.exists {
                        user2 = document.data()!["username"] as! String
                    } else {
                        print("UID2 does not exist")
                        // do error handling
                    }
                    dp.leave()
                }
                dp.notify(queue: .main) {
                    guard (user1 != "" && user2 != "" && event != nil) else {
                        // do error handling
                        // throw error about event
                        print(user1, user2, event!)
                        print("did not guard event enough")
                        return
                    }
                    let wager = Wager.init(type: EventType.game, event: event!, wagerID: wagerID)
                    wager.users = [user1, user2]
                    wager.value = value as! Int
                    switch type {
                        case "Pending":
                            print(self.tableData.count)
                            if (self.tableData.count == 0) {
                                self.tableData.append([wager])
                            } else {
                                self.tableData[0].append(wager)
                            }
                        case "Active":
                            self.tableData[1].append(wager)
                        case "Completed":
                            self.tableData[2].append(wager)
                        default:
                        // something went wrong
                            break
                    }
                    completion()
                }
            } else {
                print("no wager with ID \(wagerID)")
                completion()
                // do error handling
            }
        } // end of first getDocument
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
            //print(event.timestamp!)
            //cell.date.text = event.timestamp.toString(dateFormat: "MM/dd/yyyy")
            cell.date.text = "TBD"
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
