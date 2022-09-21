//
//  ReviewViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/30.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var toSaveButton: UIButton!
    @IBOutlet weak var saveGoalLabel: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var documentID: String? = nil
    var calendarSelectedDate: Date? = nil
    var deadlineData: [DetailGoal] = []
    var targetData: DetailGoal?
    var saveGoal = String()
    var saveId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveGoalLabel.text = targetData?.goal
    }
    
    @IBAction func tappedSave() {
        measuringStatus()
    }
    
    @IBAction func backView() {
        self.dismiss(animated: true)
    }
    
    @IBAction func tappedToSave() {
        saveShowModal()
    }
    
    private func refShowModal(value: Double, originalText: String, targetDocumentId: String, targetGoal: String, calendarDate: Date) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ReframingViewController") as! ReframingViewController
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        viewController.value = Int(value)
        viewController.originalText = originalText
        viewController.calendarDate = calendarDate
        viewController.targetDocumentID = targetDocumentId
        viewController.targetGoal = targetGoal
        present(viewController, animated: true)
    }
    
    private func saveShowModal() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SaveReviewViewController") as! SaveReviewViewController
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(viewController, animated: true)
    }
    
    // ポジティブ度を測定
    private func measuringStatus() {
        let apiClient = APIClient.shared
        apiClient.getDegreeofSentiment(encodedWord: reviewTextView.text ?? "") { [self] response in
            switch response {
            case .success(let data):
                let positiveness: Double = Double(data.negaposi+3)
                let percentage: Double = positiveness/6*100
                print("negaposi: \(positiveness)")
                print("percentage: \(percentage)")
                if data.negaposi>0 {
                    AlertDialog.shared.showAlert(title: "ポジティブ!", message: "ポジティブ\(percentage)%！", viewController: self) {
                        self.addReview(score: percentage)
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    guard let targetData = self.targetData else {
                        return
                    }
                    AlertDialog.shared.showAlert(title: "ポジティブ度が低いです…", message: "ポジティブ\(percentage)%…", viewController: self) {
                        self.refShowModal(value: percentage, originalText: self.reviewTextView.text!, targetDocumentId: targetData.documentID, targetGoal: targetData.goal, calendarDate: self.calendarSelectedDate ?? Date())
                    }
                }
                break
            case .failure(let error):
                print("error: \(error)")
                break
            }
        }
    }
    
    private func addReview(score: Double) {
        guard let user = user else {
            return
        }
        guard let targetData = targetData else {
            return
        }
        let addData: [String:Any] = [
            "original":reviewTextView.text!,
            "date":Timestamp(date: calendarSelectedDate ?? Date()),
            "target": targetData.documentID,
            "targetGoal": targetData.goal,
            "score": score
        ]
        db.collection("users")
            .document(user.uid)
            .collection("reviews")
            .addDocument(data: addData)
    }
    
    func design() {
        reviewTextView.layer.cornerRadius = 15
        reviewTextView.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 5, right: 5)
        toSaveButton.layer.cornerRadius = 10
        print("中身\(saveGoal)")
        if saveGoal.isEmpty {
            saveGoalLabel.text = "保存先を選択"
        } else {
            saveGoalLabel.text = self.saveGoal
        }
    }
}

//extension ReviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return deadlineData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        targetData = deadlineData[row]
//        documentID = deadlineData[row].documentID
//        return deadlineData[row].goal
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        documentID = deadlineData[row].documentID
//    }
//}
