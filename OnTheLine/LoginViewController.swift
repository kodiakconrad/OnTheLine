//
//  LoginViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 4/27/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase


class LoginViewController: UIViewController {
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        // Get default AuthUI object
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            return
        }
        authUI?.delegate = self         //Set ourselves as delegate
        let providers = [FUIEmailAuth()]
        authUI?.providers = providers
        
        // Get a reference with auth UI view controller
        let authViewController = authUI!.authViewController()
        
        //Show it
        present(authViewController, animated: true, completion: nil)
        print("presented")
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

extension UIViewController: FUIAuthDelegate {
    
    public func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {

        guard error == nil else {
            // log error
            return
        }
        // access uid and email for adding ot database
        if let user_id = authDataResult?.user.uid, let email = authDataResult!.user.email {
            // need to check if this is a new user or not
            // addUserToDatabase(uid: user_id, email: email)
        } else {
            // log error
            return
        }
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
}
