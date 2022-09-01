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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var logIn: UIButton!
    
    let storeRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldImage()
        design()
    }
    
    @IBAction func tappedLogIn(_ sender: Any) {
        signInUser(emailText: emailField.text!, passwordText: passwordField.text!)
    }
    
    func signInUser(emailText: String, passwordText: String) {
        auth.signIn(withEmail: emailText, password: passwordText) { AuthDataResult, Error in
            if let err = Error {
                print("error:\(err)")
            } else {
                self.transition()
            }
        }
    }
    
    func transition() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabView = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabView.modalPresentationStyle = .fullScreen
        tabView.selectedIndex = 0
        self.present(tabView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    @IBAction func deleteText1(_ sender: UIButton) {
     emailField.text = ""
    }
    
    @IBAction func deleteText2(_ sender: UIButton) {
     passwordField.text = ""
    }
    
    func design() {
        backView.layer.cornerRadius = 15
        logIn.layer.cornerRadius = 10
    }
}
