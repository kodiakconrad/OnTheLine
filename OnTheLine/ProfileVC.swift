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
