//
//  WagersVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit

class WagersVC: TabViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var wagersTableView: UITableView!
    var cellCounts = [0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCounts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header: String = ""
        switch section {
        case 0:
            header = "Pending"
        case 1:
            header = "Acive"
        case 2:
            header = "Completed"
        default:
            print("something went wrong here")
            break
        }
        return header
    }
    
    
}
