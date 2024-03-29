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
    
    @IBOutlet weak var badTextView: UITextView!
    @IBOutlet weak var reframingTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var value = Int()
    var targetGoal = String()
    var originalText = String()
    var targetDocumentID: String = ""
    var calendarDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        design()
    }
    
    @IBAction func tappedClear() {
        measuringReframing()
    }
    
    private func setUpUI() {
        clearButton.layer.cornerRadius = 15
        clearButton.clipsToBounds = true
        badTextView.text = originalText
    }
    
    private func addReframingData() {
        guard let user = user else {
            return
        }
        let addReframing: [String:Any] = [
            "original": originalText,
            "reframing": reframingTextField.text!,
            "target": self.targetDocumentID,
            "targetGoal": targetGoal,
            "score": value,
            "date": Timestamp(date: calendarDate)
        ]
        
        db.collection("users")
            .document(user.uid)
            .collection("reviews")
            .addDocument(data: addReframing)
    }
    
    private func measuringReframing() {
        let apiClient = APIClient.shared
        apiClient.getDegreeofSentiment(encodedWord: reframingTextField.text ?? "") { response in
            switch response {
            case .success(let data):
                if data.documentSentiment.score > 0 {
                    AlertDialog.shared.showSaveAlert(title: "リフレーミング完了", message: "ポジティブになりました", viewController: self) {
                        self.addReframingData()
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }
                } else {
                    AlertDialog.shared.showSaveAlert(title: "ポジティブ度が低いです…", message: "リフレーミングをもう一度してください", viewController: self) {
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
    
    func design() {
        reframingTextField.layer.borderWidth = 0.5
        reframingTextField.layer.borderColor = UIColor(named: "grayTextColor")?.cgColor
        reframingTextField.layer.cornerRadius = 15
        reframingTextField.backgroundColor = UIColor.white
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        reframingTextField.leftView = leftPadding
        reframingTextField.leftViewMode = .always
        reframingTextField.placeholder = "ポジティブな言葉にしよう"
    }
}
