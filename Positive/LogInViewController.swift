//
//  LogInViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/15.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var textFieldCollection: [UITextField]!
    
    let storeRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldImage()
    }
    
    @IBAction func tappedLogIn(_ sender: Any) {
        signInUser(emailText: emailField.text!, passwordText: passwordField.text!)
    }
    
    func signInUser(emailText: String, passwordText: String) {
        auth.signIn(withEmail: emailText, password: passwordText) { AuthDataResult, Error in
            if let err = Error {
                print("error:\(err)")
            }
            self.transition()
        }
    }
    
    func transition() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabView = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabView.modalPresentationStyle = .fullScreen
        tabView.selectedIndex = 0
        self.present(tabView, animated: true, completion: nil)
    }
    
    func fieldImage() {
        for textFieldImage in textFieldCollection {
            textFieldImage.layer.shadowOpacity = 0.5
            textFieldImage.layer.shadowColor = UIColor.gray.cgColor
            textFieldImage.layer.shadowOffset = CGSize(width: 1, height: 1)
            textFieldImage.layer.masksToBounds = false
            textFieldImage.layer.cornerRadius = 24
            let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            textFieldImage.leftView = leftPadding
            textFieldImage.leftViewMode = .always
            textFieldImage.backgroundColor = UIColor.white
        }
    }
}