//
//  LoginViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 4/17/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getUserInfo()
        //addSampleUser()
        //readAllWagers()
    }
    private func getUserInfo() {
        if let user = Auth.auth().currentUser {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            // ...
        }
    }
    @IBAction func pressedLogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("signed out")
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    private func addUserToDatabase(uid: String, email: String) {
        let userData = ["firstname": uid,
                        "email": email]
        var docRef: DocumentReference? = nil
        docRef = db.collection("Users").addDocument(data: userData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
        
    }
    
    /*
    private func readAllWagers() {
        db.collection("Wagers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
 */
}
