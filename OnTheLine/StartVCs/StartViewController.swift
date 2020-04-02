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
        print("Start VC loaded")
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initial = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = initial
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // Get default AuthUI object

    }

    @IBAction func signupTapped(_ sender: Any) {
        // deprecated for me
    }
}


/*
   Deprecated for now, opted for own sign up/sign in
 
 
// previously in logginTapped
 
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
 

extension UIViewController: FUIAuthDelegate {
    
    public func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {

        guard error == nil else {
            // log error
            return
        }
        // access uid and email for adding ot database
        if let user = authDataResult?.user {
            if user.metadata.creationDate == user.metadata.lastSignInDate {
                print("creation date is last sign in date")
                guard let email = user.email else {
                    // log error
                    print("email != user.email")
                    return
                }
                print(email)
                //addUserToDatabase(uid: user.uid, email: email)
                //addUserToLedger
            }
            // need to check if this is a new user or not
            // addUserToDatabase(uid: user_id, email: email)
        } else {
            // log error
            return
        }
        print("in delegate block")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
}

protocol addUserDelegate {
    func addUserToDB(user: User)
}
 
*/
