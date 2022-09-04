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
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var textFieldImage: [UITextField]!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func tappedImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tappedSave() {
        if emailField.text != nil && passField.text != nil{
            updateUser(emailText: emailField.text!, passwordText: passField.text!)
            self.transition()
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
                self.passField.placeholder = "新しいパスワードを入力"
            }
        let imagesRef = self.storageRef.child("userProfile").child("\(user.uid).jpg")
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, Error in
            if let Error = Error {
                print("画像の取り出しに失敗: \(Error)")
            } else {
                let image = UIImage(data: data!)
                self.imageButton.imageView?.contentMode = .scaleAspectFill
                self.imageButton.clipsToBounds = true
                self.imageButton.imageView?.image = image
                //                self.imageButton.image = image
            }
        }
    }
    
    func updateUser(emailText: String, passwordText: String) {
//        Auth.auth().createUser(withEmail: emailText, password: passwordText) { FIRAuthDataResult, Error in
//            guard let authResult = FIRAuthDataResult else { return }
//            let reference = self.storageRef.child("userProfile").child("\(authResult.user.uid).jpg")
//            guard let image = self.imageButton.imageView?.image else { return }
//            guard let uploadImage = image.jpegData(compressionQuality: 0.2) else { return }
//            reference.putData(uploadImage, metadata: nil) { (metadata, err) in
//                if let error = err {
//                    print("error: \(error)")
//                }
//            }
//        }

        guard let user = user else {
            return
        }
        
        user.updateEmail(to: emailText)
        user.updatePassword(to: passwordText)
        
        let updateData: [String:Any] = [
            "userName": self.nameField.text!
        ]
        
        db.collection("users")
            .document(user.uid)
            .updateData(updateData)
    }
    
    func transition() {
        dismiss(animated: true, completion: nil)
        //        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
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
        imageButton.layer.cornerRadius = 40
        imageButton.layer.borderWidth = 2
        imageButton.layer.borderColor = UIColor.gray.cgColor
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
}

extension EditAccountViewController: UIImagePickerControllerDelegate, UINavigationBarDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage {
//            imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
//        } else if let originalImage = info[.originalImage] as? UIImage {
//            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
        if let image = info[.editedImage] as? UIImage{
            imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        imageButton.setTitle("", for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.contentHorizontalAlignment = .fill
        imageButton.contentVerticalAlignment = .fill
        imageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}

