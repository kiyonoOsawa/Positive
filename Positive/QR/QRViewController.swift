//
//  QRViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/09/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AVFoundation
import PhotosUI
import Photos

class QRViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var camenraButton: UIButton!
    @IBOutlet weak var qrLoadButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    let str = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var storedImage: UIImage? = nil
    var storedID: String? = nil
    
    @IBAction func tappedCameraButton(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted{
                DispatchQueue.main.async {
                    self.allowAccessingCamera()
                }
            }else{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toCamera", sender: nil)
                }
            }
        }
    }
    
    @IBAction func tappedCaptureButton() {
        savePhotoToLibrary(image: takeScreenshot())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        guard let str = str else {return}
        generateQR(url: str, uiImage: qrImageView)
    }
    
    func generateQR(url: String?,uiImage: UIImageView){
        guard let url = url else {
            return
        }
        let data = url.data(using: .utf8)!
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        uiImage.image = UIImage(ciImage: qr.outputImage!.transformed(by: sizeTransform))
    }
    
    func takeScreenshot() -> UIImage {
        let width = qrImageView.bounds.size.width
        let height = qrImageView.bounds.size.height
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        qrImageView.drawHierarchy(in: qrImageView.bounds, afterScreenUpdates: true)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndPDFContext()
        return screenshotImage
    }
    
    func savePhotoToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image , self, #selector(image(image: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Failed to save photo: \(error)")
        } else {
            print("Photo saved successfully.")
        }
    }
    
    func design() {
        let mainColor = UIColor(named: "MainColor")
        let grayTextColor = UIColor(named: "grayTextColor")
        guard let mainColor = mainColor else { return }
        guard let grayTextColor = grayTextColor else { return }
        camenraButton.layer.cornerRadius = 20
        camenraButton.layer.borderColor = mainColor.cgColor
        camenraButton.layer.borderWidth = 3
        qrLoadButton.layer.cornerRadius = 20
        qrLoadButton.layer.borderColor = mainColor.cgColor
        qrLoadButton.layer.borderWidth = 1.5
        captureButton.layer.cornerRadius = 20
        captureButton.layer.borderColor = grayTextColor.cgColor
        captureButton.layer.borderWidth = 1.5
        qrImageView.backgroundColor = UIColor(named: "systemColor")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
    }
    
    private func allowAccessingCamera(){
        AlertDialog.shared.showAlert(title: "エラー", message: "カメラのアクセスを許可してください", viewController: self) {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
