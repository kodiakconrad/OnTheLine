//
//  LoginViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 4/27/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import FirebaseUI


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
        
        //Set ourselves as delegate
        authUI?.delegate = self
        
        // Get a reference with auth UI view controller
        let authViewController = authUI!.authViewController()
        
        //Show it
        present(authViewController, animated: true, completion: nil)
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
        // How to access uid after log in, will need this later
        // authDataResult?.user.uid
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
}
