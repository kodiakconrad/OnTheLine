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


class AddFriendVC: TabViewController {

    @IBOutlet weak var searchedUsername: UITextField!
    var namelabel = UILabel.newAutoLayout()
    var addButton = UIButton.newAutoLayout()
    var profile = UIImageView.newAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchedUsername.becomeFirstResponder()
    }

    @IBAction func search(_ sender: Any) {
        self.fetchUser()
        
    }
    
    func fetchUser()  {
        let userRef = db.collection("Users").document(searchedUsername.text!)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.getView(document: document)

                
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    func getView(document: DocumentSnapshot) {
        let friend = AddFriendView(frame: CGRect.zero)
        let data = document.data()
        print(type(of: data))
        let fn = data!["firstname"]
        let ln = data!["lastname"]
        print(fn!)
        print(ln!)
        friend.nameLabel.text = "\(String(describing: fn)) + \(String(describing: ln))"
        self.view.addSubview(friend)
        

    }
    
    func addNewView(to container: UIView) {
        let newView = UIView()
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
