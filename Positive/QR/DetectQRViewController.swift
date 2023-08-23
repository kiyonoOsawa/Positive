//
//  DetectQRViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2023/07/09.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import PhotosUI
import Photos

class DetectQRViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    var storedImage: UIImage? = nil
    var storedId: String? = nil
    let alertDialog = AlertDialog.shared
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
    }
    
    @IBAction func tappedImageButton(_ sender: Any) {
        displayPicker()
    }
    
    @IBAction func tappedAddFriendButton(_ sender: Any) {
        if let storedImage = self.storedImage{
            alertDialog.showSaveAlert(title: "友達追加", message: "表示されたQRから友達を追加しますか", viewController: self) {
                self.getString(image: storedImage)
                //前画面に戻る
                self.dismiss(animated: true)
            }
        }else{
            alertDialog.showSingleAlert(title: "Qrが読み込まれていません", message: "Qrを読み込んでください", viewController: self) {
                self.displayPicker()
            }
        }
    }
    
    func design() {
        let mainColor = UIColor(named: "MainColor")
        let grayTextColor = UIColor(named: "grayTextColor")
        guard let mainColor = mainColor else { return }
        guard let grayTextColor = grayTextColor else { return }
        addFriendsButton.layer.cornerRadius = 20
        addFriendsButton.layer.borderColor = mainColor.cgColor
        addFriendsButton.layer.borderWidth = 3
    }
}

extension DetectQRViewController: PHPickerViewControllerDelegate {
    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image,let ciImage = CIImage.init(image: image){
            var options: [String:Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let context = CIContext()
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
                options = [CIDetectorImageOrientation:
                            ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options:options)
            return features
        }
        return nil
    }
    
    func displayPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let user = Auth.auth().currentUser
        guard let user = user else { return }
        if let firstItemProvider = results.first?.itemProvider {
            if firstItemProvider.canLoadObject(ofClass: UIImage.self) {
                firstItemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else {
                        picker.dismiss(animated: true)
                        return
                    }
                    // QRを読み込んだ後の処理
                    self.storedImage = image
                    DispatchQueue.main.async {
                        self.imageButton.setImage(self.storedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
                        self.imageButton.setTitle("", for: .normal)
                        self.imageButton.imageView?.contentMode = .scaleAspectFill
                        self.imageButton.clipsToBounds = true
                        picker.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func getString(image: UIImage){
        guard let user = user else {return}
        //FIXME: detectQRCode(image)
        if let features = detectQRCode(image), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                guard let id = row.messageString else {return}
                self.db.collection("users")
                    .document(user.uid)
                    .updateData(["friendList": FieldValue.arrayUnion([id])])
            }
        }
    }
}

