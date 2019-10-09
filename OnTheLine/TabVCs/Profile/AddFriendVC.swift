//
//  AddFriendVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/4/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import Firebase


class AddFriendVC: TabViewController {

    @IBOutlet weak var searchedUsername: UITextField!
    
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
    func fetchUser() {
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
    
    private func getView(document: DocumentSnapshot) {
        var friend = AddFriendView(frame: CGRect.zero)
        let data = document.data()
        let fnData = data?["firstname"] as? [String: String]
        let lnData = data?["lastname"] as? [String: String]
        
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
