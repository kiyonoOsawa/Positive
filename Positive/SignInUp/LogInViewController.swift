//
//  LogInViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/15.
//

import UIKit
import Combine
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
    @IBOutlet weak var error1: UILabel!
    @IBOutlet weak var error2: UILabel!
    
    let storeRef = Storage.storage().reference(forURL: "gs://taffi-f610f.appspot.com/")
    let auth = Auth.auth()
    let authStateManager = AuthStateManager()
    let signInUpViewModel = SignInUpViewModel.shared
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        signInUpViewModel.$errMessage.sink(receiveValue: { errMessage in
            if self.authStateManager.errorMessage == "メールアドレスが違います" {
                self.error1.text = errMessage
            } else if self.authStateManager.errorMessage == "パスワードが間違っています" {
                self.error2.text = errMessage
            } else {
                self.error1.text = errMessage
                self.error2.text = errMessage
            }
        }).store(in: &cancellables)
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
        let storyboard = UIStoryboard(name: "MainStory", bundle: nil)
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
    
    private func design() {
        backView.layer.cornerRadius = 15
        logIn.layer.cornerRadius = 10
    }
    
    //    @objc func keyboardWillShow(notification: NSNotification) {
    //        if !passwordField.isFirstResponder {
    //            return
    //        }
    //
    //        if self.view.frame.origin.y == 0 {
    //            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
    //                self.view.frame.origin.y -= keyboardRect.height - passwordField.frame.origin.y
    //            }
    //        }
    //    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
