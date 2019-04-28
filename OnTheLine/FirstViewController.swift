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
        //addSampleUser()
        //readAllWagers()
    }

    
    private func addSampleUser() {
        let sample_data = [
            "firstname":"Bob",
            "email":"bob@gmail.com"
        ]
        
        var docRef: DocumentReference? = nil
        docRef = db.collection("Users").addDocument(data: sample_data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
    }
    
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
    
    /*
    private func join(itemKey) {
        const data = { [this.userId]: true}
        const members = this.db.object(`items/${itemKey}/members`)
        members.update(data)
    }
    leave(itemKey) {
    const member = this.db.object(`items/${itemKey}/members/${this.userId}`)
    member.remove()
    }
    */

}
        
        /*
        let newRef = db.collection("Users").document()
        newRef.setData(sample_data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(newRef!.documentID)")
            }
        }
        */

        // Code for Realtime Database
        
        // Do any additional setup after loading the view, typically from a nib.
        //let ref = Database.database().reference()
        //let usersRef = ref.child("Users")
        //usersRef.childByAutoId().setValue(["firstname":"Bob", "email":"bob@gmail.com"])
        //db.collection("Users")
        // Add a new document with a generated id.

