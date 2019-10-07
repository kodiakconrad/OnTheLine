//
//  AddFriendView.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/7/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit

class AddFriendView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) { // for usign view in code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using view in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AddFriendView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
