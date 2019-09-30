//
//  SetupViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 8/6/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class SetupViewController: UIViewController {

    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var username: UITextField!
    
    
    var db: Firestore!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings

        db = Firestore.firestore()
        ref = Database.database().reference()
    }
    
    @IBAction func didCreateAccount(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            let userID = user.uid
            let email = user.email
            let userRef = db.collection("Users")
            let usernameRef = userRef.document(username.text!)
            usernameRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let alertController = UIAlertController(title: "Username already taken", message: "Please try a new username", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("username was not taken")
                    self.addUserToDatabase(userID: userID, email: email ?? "")
                    self.performSegue(withIdentifier: "setupToHome", sender: self)
                }
            }
        
        } else {
            print("user does not exist")
        }
    }
    private func topmostController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    private func addUserToDatabase(userID: String, email: String) {
        let userData: [String: Any] = ["firstname": firstname.text!,
                                       "lastname": lastname.text!,
                                       "email": email,
                                       "uid": userID]
        db.collection("Users").document(username.text!).setData(userData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
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

}
