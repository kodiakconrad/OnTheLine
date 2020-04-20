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
    var wagerData = [[String](), [String](), [String]()]
    var tableData = [[Wager]]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated
        )
        self.retrieveWagerIDs() {
            self.collectWagerData {
                self.cellCounts[0] = self.wagerData[0].count
                self.cellCounts[1] = self.wagerData[1].count
                self.cellCounts[2] = self.wagerData[2].count
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
                self.wagerData[0] = data?["Pending"] as! [String]
                self.wagerData[1] = data?["Active"] as! [String]
                self.wagerData[2] = data?["Completed"] as! [String]
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
        let myGroup = DispatchGroup()
        if self.wagerData[0].count != 0 {
            for wagerID in self.wagerData[0] {
                myGroup.enter()
                print(wagerID)
                self.getWager(wagerID: wagerID, type: "Pending") {
                    myGroup.leave()
                }
            }
  
        }
        if self.wagerData[1].count != 0 {
            myGroup.enter()
            for wagerID in self.wagerData[1] {
                self.getWager(wagerID: wagerID, type: "Active") {
                    myGroup.leave()
                }

            }

        }
        if self.wagerData[2].count != 0 {
            myGroup.enter()
            for wagerID in self.wagerData[2] {
                self.getWager(wagerID: wagerID, type: "Completed") {
                    myGroup.leave()
                }
            }
        }
        myGroup.notify(queue: .main) {
            completion()
        }

    }
    
    func getWager(wagerID: String, type: String, completion: @escaping () -> Void) {
        let wagerRef = db.collection(WAGERS).document(wagerID)
        wagerRef.getDocument() {
            (document, error) in
            if error != nil {
                print("error in getWager")
                print(error.debugDescription)
            }
            if let document = document, document.exists {
                let data = document.data()!
                let uid1 = data["uid1"] as! String
                let uid2 = data["uid2"] as! String
                let value = data["Value"]
                let eventID = data["Event"] //change to "eventID"
                let winner = data["winner"] ?? ""
                // Remember: UID1 is home team. UID2 is away team
                let eventRef = self.db.collection(self.EVENTS).document(eventID! as! String)
                let userRef = self.db.collection(self.USERS)
                var users = [String: String]()
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
                        users[uid1] = (document.data()!["username"] as! String)
                    } else {
                        print("UID1 does not exist")
                        // do error handling
                    }
                    dp.leave()
                }
                dp.enter()
                userRef.document(uid2).getDocument { (document, error) in
                    if let document = document, document.exists {
                        users[uid2] = (document.data()!["username"] as! String)
                    } else {
                        print("UID2 does not exist")
                        // do error handling
                    }
                    dp.leave()
                }
                dp.notify(queue: .main) {
                    guard (!users.isEmpty && event != nil) else {
                        // do error handling
                        // throw error about event
                        print("did not guard event enough")
                        return
                    }
                    let wager = Wager.init(type: EventType.game, event: event!, wagerID: wagerID)
                    let user1 = users[uid1]!
                    let user2 = users[uid2]!
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
        if indexPath.section == 0 {
            cell.backgroundColor = .systemYellow
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemBlue
        } else {
            // TODO: green background for all victories and red for all losses
        }
        let cellData = tableData[indexPath.section][indexPath.row]
        let event = cellData.event
        switch cellData.type {
            case .game:
            print("case game")
            cell.away.text = event.awayTeam
            cell.home.text = event.homeTeam
            // TODO: Make timestamp work
            //print(event.timestamp!)
            //cell.date.text = event.timestamp.toString(dateFormat: "MM/dd/yyyy")
            cell.date.text = "TBD"
            cell.spread.text = String(event.spread)
            // TODO: Change when
            cell.value.text = String(cellData.value)
            cell.user1.text = cellData.users[0]
            cell.user2.text = cellData.users[1]
            case .statistic:
            print("case statistic")
            case .outcome:
            print("case outcome")
        }
        cell.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(pressedCell)))
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    @objc func pressedCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let wagerVC = storyboard.instantiateViewController(withIdentifier: "singleWager")
        self.navigationController?.pushViewController(wagerVC, animated: true)
    }
    
    func acceptWager() {
        // TODO: implement
    }
    
    func declineWager() {
        // TODO: implement
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


class WagerTapGestureRecognizer: UITapGestureRecognizer {
    var opponentUsername : String?
    
    init(target: Any?, action: Selector?, username: String) {
        super.init(target: target, action: action)
        opponentUsername = username
    }
}
