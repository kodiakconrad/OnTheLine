//
//  StartViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 4/27/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import FirebaseUI


class StartViewController: UIViewController {
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goHome", sender: nil)
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
       /*
        // Get default AuthUI object

        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            return
        }
        authUI?.delegate = self         //Set ourselves as delegate
        let providers :[FUIAuthProvider] = [
                        FUIEmailAuth(),
                        FUIGoogleAuth(),
                        FUIFacebookAuth(),]
        authUI?.providers = providers
        
        // Get a reference with auth UI view controller
        let authViewController = authUI!.authViewController()
        
        //Show it
        present(authViewController, animated: true, completion: nil)
 */
        
    }

    @IBAction func signupTapped(_ sender: Any) {
        
    }
    
    /*
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
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController: FUIAuthDelegate {
    
    public func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {

        guard error == nil else {
            // log error
            return
        }
        // access uid and email for adding ot database
        if let user = authDataResult?.user {
            if user.metadata.creationDate == user.metadata.lastSignInDate {
                guard let email = user.email else {
                    // log error
                    return
                }
                print(email)
                //addUserToDatabase(uid: user.uid, email: email)
            }
            // need to check if this is a new user or not
            // addUserToDatabase(uid: user_id, email: email)
        } else {
            // log error
            return
        }
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
    
}
