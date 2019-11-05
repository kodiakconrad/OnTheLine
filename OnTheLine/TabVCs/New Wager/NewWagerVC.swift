//
//  NewWagerVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit

class NewWagerVC: TabViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var eventView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
        //need to create cancel button
        
    }

    @IBAction func switchViews(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gameView.alpha = 1
            statView.alpha = 0
            eventView.alpha = 0
        case 1:
            statView.alpha = 1
            gameView.alpha = 0
            eventView.alpha = 0
        case 2:
            eventView.alpha = 1
            gameView.alpha = 0
            statView.alpha = 0
        default:
            break;
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
