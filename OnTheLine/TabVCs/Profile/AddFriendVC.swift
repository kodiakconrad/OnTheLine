//
//  AddFriendVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/4/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import Firebase
import PureLayout


class AddFriendVC: TabViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userData: [String: Any]? = nil
    var friendUid = ""
    var numUsers = 0

    @IBOutlet weak var searchedUsername: UITextField!
    @IBOutlet weak var nameTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userData.map(String.init(describing:)) ?? "nil")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchedUsername.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        if userData != nil {
            let name = userData!["name"]
            cell.nameLabel.text = ("\(name!)")
            //cell.textLabel?.text = ("\(String(describing:fn)) + \(String(describing: ln))")
        } else {
            cell.nameLabel.text = "No users found"
        }
        return cell
    }

    @IBAction func search(_ sender: Any) {
        self.fetchUser()
        
    }
    
    func fetchUser()  {
        let userRef = db.collection("Usernames").document(searchedUsername.text!)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //friendUid = document.data()!["uid"] as! String
                let friendUid = document.data()!["uid"] as! String
                self.friendUid = friendUid
                let dataRef = self.db.collection("Users").document(friendUid)
                dataRef.getDocument { (doc, er) in
                    if let doc = doc, doc.exists {
                        self.userData = doc.data()!
                    }
                }
                self.numUsers = 1
                
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)"
                
            } else {
                print("Document does not exist")
            }
            self.nameTable.reloadData()
        }
    }
    @IBAction func addFriend(_ sender: Any) {
        //add friend to your databas
        //let uid = Auth.auth().currentUser?.uid
        db.collection("Users").document(self.uid).collection("friends").document(friendUid).setData(["status": "pending"])
        //need to error check

        //send alert to other person
        db.collection("Users").document(friendUid).collection("friends").document(uid).setData(["status": "pending"] )
    }
    
}

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
