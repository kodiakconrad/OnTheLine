//
//  EventTypeVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 3/31/20.
//  Copyright © 2020 Kodiak Conrad. All rights reserved.
//

import UIKit

class EventTypeVC: TabViewController {
    
    var opponent: String = "default"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EventTypeVC {
            let vc = segue.destination as! EventTypeVC
            vc.opponent = self.opponent
        }
    }
}
