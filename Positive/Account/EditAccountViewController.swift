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

class EditAccountViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var textFieldImage: [UITextField]!
    
//    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        fetchMyData()
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
    
    @IBAction func tappedSave() {
        if emailField.text != nil && passField.text != nil{
            guard let userEmail = user?.email else {return}
            guard let user = user else {return}
            let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
            user.reauthenticate(with: credential) { AuthDataResult, Error in
                self.updateUser(emailText: self.emailField.text!, passwordText: self.passField.text!)
                self.transition()
            }
        }
    }
    
    private func fetchMyData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .addSnapshotListener { DocumentSnapshot, Error in
                guard let documentSnapshot = DocumentSnapshot else { return }
                guard let data = documentSnapshot.data() else { return }
                let myAccount = User(userData: data)
                self.nameField.text = myAccount.userName
                self.emailField.text = user.email
                self.password = myAccount.password ?? ""
                self.passField.placeholder = "新しいパスワードを入力"
            }
    }
    
    func updateUser(emailText: String, passwordText: String) {
        guard let user = user else {
            return
        }
        
        user.updateEmail(to: emailText)
        user.updatePassword(to: passwordText)
        
        let updateData: [String:Any] = [
            "userName": self.nameField.text!,
            "password": self.passField.text!
        ]
        
        db.collection("users")
            .document(user.uid)
            .updateData(updateData)
    }
    
    func transition() {
        dismiss(animated: true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func design() {
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
            textFieldImage.backgroundColor = UIColor.white
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !passField.isFirstResponder {
            return
        }
        
        if self.view.frame.origin.y == 0 {
            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardRect.height - passField.frame.origin.y
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

