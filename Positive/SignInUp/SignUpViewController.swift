//
//  SignUpViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/01.
//

import UIKit
import Combine
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var error1: UILabel!
    @IBOutlet weak var error2: UILabel!
    
    let storageRef = Storage.storage().reference(forURL: "gs://taffi-f610f.appspot.com/")
    let user = Auth.auth().currentUser
    let authStateManager = AuthStateManager.shared
    let signInUpViewModel = SignInUpViewModel.shared
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        signInUpViewModel.$errMessage.sink(receiveValue: { errMessage in
            if self.authStateManager.errorMessage == "メールアドレスは既に利用されています" {
                self.error1.text = errMessage
        } else if self.authStateManager.errorMessage == "パスワードを強力にしてください" {
                self.error2.text = errMessage
        }
        }).store(in: &cancellables)
        fieldImage()
        design()
    }
    
    @IBAction func tappedImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tappedSignUp(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil{
            authStateManager.createUser(emailText: emailField.text!, passwordText: passwordField.text!) { uid in
                let reference = self.storageRef.child("userProfile").child("\(uid).jpg")
                guard let image = self.userImageButton.imageView?.image else {
                    return
                }
                guard let uploadImage = image.jpegData(compressionQuality: 0.2) else {
                    return
                }
                reference.putData(uploadImage, metadata: nil) { (metadata, err) in
                    if let error = err {
                        print("error: \(error)")
                    }
                }
                let addData: [String:Any] = [
                    "userName": self.userNameField.text!,
                    "userId": uid,
                    "password": self.passwordField.text!
                ] as [String : Any]
                let db = Firestore.firestore()
                db.collection("users")
                    .document(uid)
                    .setData(addData)
                self.transition()
            }
        }
    }
    
    @IBAction func tappedToLogIn(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogIn", sender: nil)
//        let storyboard: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "logInVC")
//        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func createUser(emailText: String, passwordText: String) {
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { FIRAuthDataResult, Error in
            guard let authResult = FIRAuthDataResult else {
                self.authStateManager.handlingError(error: Error!)
                print("error: \(Error)")
                return
            }
            let reference = self.storageRef.child("userProfile").child("\(authResult.user.uid).jpg")
            guard let image = self.userImageButton.imageView?.image else {
                return
            }
            guard let uploadImage = image.jpegData(compressionQuality: 0.2) else {
                return
            }
            reference.putData(uploadImage, metadata: nil) { (metadata, err) in
                if let error = err {
                    print("error: \(error)")
                }
            }
            let addData: [String:Any] = [
                "userName": self.userNameField.text!,
                "userId": authResult.user.uid,
                "password": self.passwordField.text!
            ] as [String : Any]
            let db = Firestore.firestore()
            db.collection("users")
                .document(authResult.user.uid)
                .setData(addData)
            self.transition()
        }
    }
    
    @IBAction func tappedToTutorial() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "PagingView") as! PagingViewController
               vc.fromSignUp = true
               self.present(vc, animated: true)
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
        passwordField.isSecureTextEntry = true
    }
    
    @IBAction func deleteText1(_ sender: UIButton) {
     userNameField.text = ""
    }
    
    @IBAction func deleteText2(_ sender: UIButton) {
     emailField.text = ""
    }
    
    @IBAction func deleteText3(_ sender: UIButton) {
     passwordField.text = ""
    }
    
    private func design() {
        userImageButton.layer.cornerRadius = 40
        userImageButton.layer.borderWidth = 1
        userImageButton.layer.borderColor = UIColor.darkGray.cgColor
        backView.layer.cornerRadius = 15
        signUp.layer.cornerRadius = 10
        error1.text = authStateManager.errorMessage
        error2.text = authStateManager.errorMessage
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !passwordField.isFirstResponder {
            return
        }
    
        if self.view.frame.origin.y == 0 {
            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardRect.height - passwordField.frame.origin.y
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            userImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            userImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        userImageButton.setTitle("", for: .normal)
        userImageButton.imageView?.contentMode = .scaleAspectFill
        userImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
