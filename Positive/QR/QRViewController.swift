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

class QRViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var camenraButton: UIButton!
    
    let str = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
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
    
    func design() {
        let mainColor = UIColor(named: "MainColor")
        guard let mainColor = mainColor else { return }
        camenraButton.layer.cornerRadius = 20
        camenraButton.layer.borderColor = mainColor.cgColor
        camenraButton.layer.borderWidth = 3
        qrImageView.backgroundColor = UIColor(named: "systemColor")
    }
    
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
    
    private func allowAccessingCamera(){
        AlertDialog.shared.showAlert(title: "エラー", message: "カメラのアクセスを許可してください", viewController: self) {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    //    @IBAction func tappedCameraButton(_ sender: Any) {
    //          var status = AVCaptureDevice.authorizationStatus(for: .video)
    //
    //          switch status{
    //          case .authorized:
    //              self.performSegue(withIdentifier: "toCamera", sender: nil)
    //          case .notDetermined:
    //              AlertDialog.shared.showAlert(title: "エラー", message: "ユーザにカメラのアクセスが許可されていません", viewController: self) {
    //                  print("error")
    //              }
    //          case .restricted:
    //              AVCaptureDevice.requestAccess(for: .video) { isGranted in
    //                  if isGranted{
    //                      self.performSegue(withIdentifier: "toCamera", sender: nil)
    //                  }else{
    //                      status = .denied
    //                  }
    //              }
    //          case .denied:
    //              AlertDialog.shared.showAlert(title: "エラー", message: "アクセス許可されていません", viewController: self) {
    //                  AVCaptureDevice.requestAccess(for: .video) { isGranted in
    //                      if isGranted{
    //                          self.performSegue(withIdentifier: "toCamera", sender: nil)
    //                      }
    //                  }
    //              }
    //          default:
    //              break
    //          }
    //      }
}
