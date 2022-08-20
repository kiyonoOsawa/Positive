//
//  ReframingViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ReframingViewController: UIViewController {
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var graphViewWidth: NSLayoutConstraint!
    @IBOutlet weak var reframingTextView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var value = Int()
    var originalText = String()
    var targetDocumentID: String = ""
    var calendarDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        graphViewWidth.constant = CGFloat(value*50)
        clearButton.layer.cornerRadius = 15
        clearButton.clipsToBounds = true
        clearButton.layer.shadowColor = UIColor.black.cgColor
        clearButton.layer.shadowOpacity = 0.2
        clearButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        clearButton.layer.masksToBounds = false
        reframingTextView.text = originalText
    }
    
    private func addReframingData() {
        guard let user = user else {
            return
        }
        let addReframing: [String:Any] = [
            "original": originalText,
            "regraming": reframingTextView.text!,
            "target": self.targetDocumentID,
            "date": Timestamp(date: calendarDate)
        ]
        db.collection("users")
            .document(user.uid)
            .collection("reviews")
            .addDocument(data: addReframing)
    }
    
    private func measuringReframing() {
        let apiClient = APIClient.shared
        apiClient.getDegreeofSentiment(encodedWord: reframingTextView.text ?? "") { response in
            switch response {
            case .success(let data):
                if data.negaposi > 0 {
                    AlertDialog.shared.showAlert(title: "リフレーミング完了", message: "ポジティブになりました", viewController: self) {
                        self.addReframingData()
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }
                } else {
                    AlertDialog.shared.showAlert(title: "ポジティブ度が低いです…", message: "リフレーミングをもう一度してください", viewController: self) {
                        print("はにゃ")
                    }
                }
                break
            case .failure(let error):
                print("error: \(error)")
                break
            }
        }
    }
}
