//
//  SingleWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 4/20/20.
//  Copyright © 2020 Kodiak Conrad. All rights reserved.
//

import UIKit
class SingleWagerVC: UIViewController {
    
    var wager:Wager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uname1 = wager?.users[0]
        let uname2 = wager?.users[1]
        let wagerID = wager?.wagerID
        // get two user IDs
        // compare to self, find other user id


        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
