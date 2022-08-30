//
//  EditAccountViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var textFieldImage: [UITextField]!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
    }
    
    @IBAction func tappedLogOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "firstAccView")
            nextVC?.modalPresentationStyle = .fullScreen
            self.present(nextVC!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func deleteText1(_ sender: UIButton) {
        nameField.text = ""
    }
    
    @IBAction func deleteText2(_ sender: UIButton) {
        emailField.text = ""
    }
    
    @IBAction func deleteText3(_ sender: UIButton) {
        passField.text = ""
    }
    
    func design() {
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 10
        for textFieldImage in textFieldImage {
            textFieldImage.layer.shadowOpacity = 0.5
            textFieldImage.layer.shadowColor = UIColor.gray.cgColor
            textFieldImage.layer.shadowOffset = CGSize(width: 1, height: 1)
            textFieldImage.layer.masksToBounds = false
            textFieldImage.layer.cornerRadius = 24
            let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            textFieldImage.leftView = leftPadding
            textFieldImage.leftViewMode = .always
            textFieldImage.backgroundColor = UIColor.white        }
    }
}
