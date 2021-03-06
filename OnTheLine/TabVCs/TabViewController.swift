//
//  TabViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/4/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class TabViewController: UIViewController {
    var db: Firestore!
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    var uid: String = ""
    let EVENTS = "Events"
    let WAGERS = "Wagers"
    let USERS = "Users"
    let LEDGER = "Ledger"
    let USERNAMES = "Usernames"

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            self.uid = (Auth.auth().currentUser?.uid)!
            // User is signed in.
        } else {
            print("no user signed in")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let startVC = storyboard.instantiateViewController(withIdentifier: "startNavVC") as! UINavigationController
            startVC.modalPresentationStyle = .fullScreen
            self.present(startVC, animated: true, completion: nil)
        }
        let ( _, _) = getUserInfo()
    }
    
    func getUserInfo() -> (String, String) {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let email = user.email!
            return (uid, email)
        }
        else {return ("", "")}
    }
}
