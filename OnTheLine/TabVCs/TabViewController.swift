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
    override func viewDidAppear(_ animated: Bool) {
        let friendsRef = db.collection("Users").document(self.uid).collection("friends")
        friendsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching collection: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New friend: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified friend: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed friend: \(diff.document.data())")
                }
                let newFriends = friendsRef.whereField("status", isEqualTo: "pending")
                newFriends.getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        print("error getting docs: \(err)")
                    } else {
                        for doc in querySnapshot!.documents {
                            print(doc)
                            let alertController = UIAlertController(title: "New Friend", message: "from friend a", preferredStyle: .alert)
                            let acceptAction = UIAlertAction(title: "Accept", style: .default , handler: { action in
                                self.acceptFriend(friendRef: friendsRef)})
                            let declineAction = UIAlertAction(title: "Decline", style: .cancel , handler: { action in
                                self.declineFriend(friendRef: friendsRef)})
                            alertController.addAction(acceptAction)
                            alertController.addAction(declineAction)
                            self.present(alertController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func acceptFriend(friendRef: CollectionReference) {
        friendRef.setValue("Active", forKey: "status")
        //is not working yet
    }
    
    func declineFriend(friendRef: CollectionReference) {
        
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
