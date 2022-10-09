//
//  QuestionViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/19.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTableView: UITableView!
    
    var data: [Bool] = []
    var targets: [[String: Any]] = []
    var answers: [DetailGoal] = []
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let questions: [String] = ["このためにできることは？ 小さな目標", "このために必要なモノ・コトは？", "きっかけは？"]
    var eachAnswer: [String] = ["","",""]
    fileprivate let cellHeight: CGFloat = 30
    fileprivate let numberOfQuestion: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        navigationItem.title = "詳細"
        for _ in 0...numberOfQuestion {
            data.append(false)
        }
        design()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         transferValue()
     }
    
    @objc private func back() {
        transferValue()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func transferValue() {
        TransferValue.shared.transferValue(nowToDo: eachAnswer[0], essentialThing: eachAnswer[1], trigger: eachAnswer[2])
    }
    
    private func fetchData() {
        guard let user = user else {
            return
        }
        self.answers.removeAll()
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                for doc in querySnapshot.documents{
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    self.answers.append(detailGoal)
                }
                self.questionTableView.reloadData()
            }
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
    }
}

extension QuestionViewController: QuestionTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    func didChangeText(cell: QuestionTableViewCell, text: String) {
        if let indexPath = questionTableView.indexPath(for: cell) {
            eachAnswer[indexPath.row] = text
        }
    }
    
    func didExtendButton(cell: QuestionTableViewCell) {
        if let indexPath = questionTableView.indexPath(for: cell) {
            if data[indexPath.row] {
                eachAnswer[indexPath.row] = cell.answerTextView.text!
            }
            cell.answerTextView.text?.removeAll()
            data[indexPath.row].toggle()
            questionTableView.reloadRows(at: [indexPath], with: .automatic)
            print(data)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfQuestion
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.questionLabel.text = questions[indexPath.row]
        cell.answerTextView.text = eachAnswer[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data[indexPath.row] {
            return 200
        } else {
            return 64
        }
        return tableView.estimatedRowHeight
    }
    
    func setDismissKeyboard() {
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
