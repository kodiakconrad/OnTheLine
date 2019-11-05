//
//  ProfileVC.swift
//  
//
//  Created by Kodiak Conrad on 10/1/19.
//

import UIKit
import Firebase

class ProfileVC: TabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
                            let friendID = doc.documentID
                            let friendName = doc["name"]!
                            let alertController = UIAlertController(title: "New Friend", message: "from friend \(friendName)", preferredStyle: .alert)
                            let acceptAction = UIAlertAction(title: "Accept", style: .default , handler: { action in
                                self.acceptFriend(uid: friendID)})
                            let declineAction = UIAlertAction(title: "Decline", style: .cancel , handler: { action in
                                self.declineFriend(uid: friendID)})
                            alertController.addAction(acceptAction)
                            alertController.addAction(declineAction)
                            self.present(alertController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func acceptFriend(uid: String) {
        let userRef = db.collection("Users")
        userRef.document(self.uid).collection("friends").document(uid).setData(["status": "active"], mergeFields: ["status"])
        userRef.document(uid).collection("friends").document(self.uid).setData(["status": "active"], mergeFields: ["status"])
    }
    
    func declineFriend(uid: String) {
        let userRef = db.collection("Users")
        userRef.document(self.uid).collection("friends").document(uid).delete()
        userRef.document(uid).collection("friends").document(self.uid).delete()
    }

    @IBAction func addFriend(_ sender: Any) {
        self.performSegue(withIdentifier: "addFriend", sender: self)
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
