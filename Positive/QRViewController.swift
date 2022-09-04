//
//  QRViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/09/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class QRViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    let str = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
