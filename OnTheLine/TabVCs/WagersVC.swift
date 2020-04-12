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
    var cellCounts = [1,1,1]
    var active = [String]()
    var pending = [String]()
    var completed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveWagers() {
            //print("retrieved wagers")
            self.getPending()
            self.getActive()
            self.getCompleted()
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCounts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeCell", for: indexPath) as! GameTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header: String = ""
        switch section {
        case 0:
            header = "Pending"
        case 1:
            header = "Acive"
        case 2:
            header = "Completed"
        default:
            print("something went wrong here")
            break
        }
        return header
    }
    
    
    // get the three lists of wagerIDs from the "Ledger"
    // collection
    func retrieveWagers(completion: @escaping () -> Void) {
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
    
    func getPending() {
        
    }
    
    func getActive() {
        
    }
    
    func getCompleted() {
        
    }
}

class GameTableViewCell: UITableViewCell{
    @IBOutlet weak var away: UILabel!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var spread: UILabel!
    @IBOutlet weak var user1: UILabel!
    @IBOutlet weak var user2: UILabel!
    
}
