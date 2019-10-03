//
//  SignUpViewController.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 8/6/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedCreateAccount(_ sender: Any) {
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            print("creating user")
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                print("user created")
                if error == nil {
                    print("creating account")
                    self.createAccount()
                    self.performSegue(withIdentifier: "setupToHome", sender: self)
                }
                else{
                    print(error.debugDescription)
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            print("done")
        }
    }
    
    private func createAccount() {
        guard let user = Auth.auth().currentUser else {
            print("User Not Created")
            return
        }
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
                self.addUserToDatabase()
                self.performSegue(withIdentifier: "setupToHome", sender: self)
            }
        }
    }
    
    private func addUserToDatabase() {
        let userData: [String: Any] = ["firstname": firstname.text!,
                                       "lastname": lastname.text!,
                                       "email": email.text!,
                                       "username": username.text!]
        db.collection("Users").document(username.text!).setData(userData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
