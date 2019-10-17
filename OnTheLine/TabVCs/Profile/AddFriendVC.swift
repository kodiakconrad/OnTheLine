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
    var users = 0

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
        return users
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        if userData != nil {
            let fn = userData!["firstname"]
            let ln = userData!["lastname"]
            cell.nameLabel.text = ("\(fn!) \(ln!)")
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
        let userRef = db.collection("Users").document(searchedUsername.text!)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userData = document.data()!
                self.users = 1
                
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)")
                //self.getView(document: document)
            } else {
                print("Document does not exist")
            }
            self.nameTable.reloadData()
           
        }
    }
    @IBAction func addFriend(_ sender: Any) {
        
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
