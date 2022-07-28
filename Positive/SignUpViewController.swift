//
//  SignUpViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/01.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var textFieldCollection: [UITextField]!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldImage()
    }
    
    @IBAction func tappedImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tappedSignUp(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            createUser(emailText: emailField.text!, passwordText: passwordField.text!)
        }
    }
    
    @IBAction func tappedToLogIn(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    func createUser(emailText: String, passwordText: String) {
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { FIRAuthDataResult, Error in
            guard let authResult = FIRAuthDataResult else {
                print("error: SignUp")
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
            let addData = [
                "person": self.userNameField.text!,
                "person": self.userImageButton.imageView
            ] as [String : Any]
            let db = Firebase.Firestore.firestore()
            db.collection("users")
                .document(authResult.user.uid)
                .setData(addData)
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            userImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            userImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        userImageButton.setTitle("", for: .normal)
        userImageButton.imageView?.contentMode = .scaleAspectFill
        userImageButton.contentHorizontalAlignment = .fill
        userImageButton.contentVerticalAlignment = .fill
        userImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
