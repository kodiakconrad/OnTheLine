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

class TabViewController: UIViewController {
    var db: Firestore!
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    var uid: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
            self.uid = (Auth.auth().currentUser?.uid)!
            // User is signed in.
        } else {
            // No user is signed in.
        }
        let (uid, email) = getUserInfo()
        print (uid, email)
    }
    
    private func getUserInfo() -> (String, String) {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let email = user.email!
            return (uid, email)
        }
        else {return ("", "")}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
