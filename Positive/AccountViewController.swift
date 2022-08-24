//
//  AccountViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/15.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func design() {
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
