//
//  AddFriendVC.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/4/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import UIKit


class AddFriendVC: TabViewController {

    @IBOutlet weak var searchedUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchedUsername.becomeFirstResponder()
    }
    
    @IBAction func search(_ sender: Any) {
        self.fetchUser()
    }
    func fetchUser() {
        let userRef = db.collection("Users").document(searchedUsername.text!)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
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
class PersonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    let nameView: UIView = {
        let view = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
        return view
    }()
    
    let addFriend: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage: systemName: , for: .normal)
        return button
    }()

}
