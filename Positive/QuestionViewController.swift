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
    let questions: [String] = ["このためにできることは？", "このために必要なモノ・コトは？", "きっかけは？", "具体的にどんな人？"]
    var eachAnswer: [String] = ["","","",""]
    fileprivate let cellHeight: CGFloat = 30
    fileprivate let numberOfQuestion: Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        navigationItem.title = "詳細"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back))
        for _ in 0...numberOfQuestion {
            data.append(false)
        }
        design()
    }
    
    @objc private func back() {
        transferValue()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func transferValue() {
        let preNC = self.navigationController!
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! MakeTargetViewController
        preVC.nowTodo = eachAnswer[0]
        preVC.essentialThing = eachAnswer[1]
        preVC.trigger = eachAnswer[2]
        preVC.person = eachAnswer[3]
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
        if indexPath.row == 0 {
            cell.popButton.isHidden = true
        } else {
            cell.popButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row == 0 {
            return 200
        } else {
            if data[indexPath.row] {
                return 200
            } else {
                return 48
            }
        }
        return tableView.estimatedRowHeight
    }
}
