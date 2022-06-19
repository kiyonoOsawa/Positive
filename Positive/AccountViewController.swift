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

    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
