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
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var questionTableView: UITableView!

    var data: [Bool] = []
    var targets: [[String: Any]] = []
    var answers: [DetailGoal] = []
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let questions: [String] = ["今すぐにできることは？","頑張ればできることは？", "このために必要なモノ・コトは？", "きっかけは？", "具体的にどんな人？"]
    
    fileprivate let cellHeight: CGFloat = 30
    fileprivate let numberOfQuestion: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        navigationItem.title = "Question"
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
        let firstCell: QuestionTableViewCell = questionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! QuestionTableViewCell
        preVC.nowTodo = firstCell.answerField.text ?? ""
        let secondCell: QuestionTableViewCell = questionTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! QuestionTableViewCell
        preVC.fightTodo = secondCell.answerField.text ?? ""
        let thirdCell: QuestionTableViewCell = questionTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! QuestionTableViewCell
        preVC.essentialThing = thirdCell.answerField.text ?? ""
        let fourthCell: QuestionTableViewCell = questionTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! QuestionTableViewCell
        preVC.trigger = fourthCell.answerField.text ?? ""
        let fifthCell: QuestionTableViewCell = questionTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! QuestionTableViewCell
        preVC.person = fifthCell.answerField.text ?? ""
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
        self.navigationController?.navigationBar.tintColor = UIColor(named: "MainColor")
    }
}

extension QuestionViewController: QuestionTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func didExtendButton(cell: QuestionTableViewCell) {
        if let indexPath = questionTableView.indexPath(for: cell) {
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
        if indexPath.row == 2 {
            cell.answerField.placeholder = "お金、能力..."
//            cell.answerField.placeholderco
        } else {
            cell.answerField.placeholder = "Input..."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data[indexPath.row] {
                return 200
            } else {
                return 56
            }
        return tableView.estimatedRowHeight
    }
}
