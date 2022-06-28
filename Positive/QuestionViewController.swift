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
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var data: [Bool] = []
    var targets: [[String:Any]] = []
    
    fileprivate let cellHeight: CGFloat = 30
    fileprivate let numberOfQuestion: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        for _ in 0...numberOfQuestion {
            data.append(false)
        }
        updateFireStore()
    }
    
    func updateFireStore() {
        let user = user
        guard let user = user else { return }
        let addData:[String: Any] = ["targets": targets]
        db.collection("users")
            .document(user.uid)
            .collection("target")
            .addDocument(data: addData)
        print("ここ通った")
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data[indexPath.row] {
                return 200
            } else {
                return 68
            }
        return tableView.estimatedRowHeight
    }
}
