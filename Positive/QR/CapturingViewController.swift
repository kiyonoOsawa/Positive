//
//  CapturingViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/29.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class CapturingViewController: UIViewController {
    
    var cancellables: Set<AnyCancellable> = []
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let myQRCodeReader = MyQRCodeReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        myQRCodeReader.delegate = self
        myQRCodeReader.setupCamera(view:self.view)
        //読み込めるカメラ範囲
        myQRCodeReader.readRange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myQRCodeReader.$cameraStatus.sink { status in
            if status != .authorized{
                self.allowAccessingCamera()
            }
        }.store(in: &cancellables)
    }
    private func allowAccessingCamera(){
        AlertDialog.shared.showAlert(title: "エラー", message: "カメラのアクセスを許可してください", viewController: self) {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

extension CapturingViewController: AVCaptureMetadataOutputObjectsDelegate{
    //対象を認識、読み込んだ時に呼ばれる
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //一画面上に複数のQRがある場合、複数読み込むが今回は便宜的に先頭のオブジェクトを処理
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            let barCode = myQRCodeReader.previewLayer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
            //読み込んだQRを映像上で枠を囲む。ユーザへの通知。必要な時は記述しなくてよい。
            myQRCodeReader.qrView.frame = barCode.bounds
            //QRデータを表示
            if let str = metadata.stringValue {
                guard let user = user else {return}
                AlertDialog.shared.showAlert(title: "友達登録", message: "フレンド登録しますか？", viewController: self) {
                    self.db.collection("users")
                        .document(user.uid)
                        .updateData(["friendList": FieldValue.arrayUnion([str])])
                    self.db.collection("users")
                        .document(str)
                        .updateData(["friendList": FieldValue.arrayUnion([user.uid])])
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                }
            }
        }
    }
}
