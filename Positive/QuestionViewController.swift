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
    
//    let db = Firestore.firestore()
//    let user = Auth.auth().currentUser
    var data: [Bool] = []
    var targets: [[String: Any]] = []
    var answers: [[String: Any]] = []
    let questions: [String] = ["今すぐにできることは？","頑張ればできることは？", "このために必要なモノ・コトは？", "きっかけは？", "具体的にどんな人？"]
    
    fileprivate let cellHeight: CGFloat = 30
    fileprivate let numberOfQuestion: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        navigationItem.title = "Question"
        for _ in 0...numberOfQuestion {
            data.append(false)
        }
//        updateFireStore()
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
        let answer = cell.answerField.text
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
