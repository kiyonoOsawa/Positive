//
//  MakeTargetViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MakeTargetViewController: UIViewController {
    
    @IBOutlet weak var sectionTableView: UITableView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var data: Bool = false
    var addData: [String: Any] = [:]
    var targetCell: MakeTargetTableViewCell!
    var detailCell: ImportanceTableViewCell!
    var importanceCell: ImportanceTableViewCell!
    var nowTodo = String()
    var fightTodo = String()
    var essentialThing = String()
    var trigger = String()
    var person = String()
    var dateCell: DateTargetTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTableView.register(UINib(nibName: "MakeTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "makeTargetCell")
        sectionTableView.register(UINib(nibName: "ImportanceTableViewCell", bundle: nil), forCellReuseIdentifier: "importanceCell")
        sectionTableView.register(UINib(nibName: "DateTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "dateTargetCell")
//        dateCell.delegate = self
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
        navigationItem.title = "New Goal"
    }
    
    @IBAction func tappedSaveButton() {
        addQuestion()
    }
    
    private func addQuestion() {
        guard let user = user else {
            return
        }
//        let convertedDate = dateFormat(date: dateCell.datePicker.date)
        let addData: [String:Any] = [
            "goal": targetCell.targetTextField.text ?? "",
            "importance": importanceCell.levelStepper.value,
            "nowTodo": self.nowTodo,
            "fightTodo": self.fightTodo,
            "essentialThing": self.essentialThing,
            "trigger": self.trigger,
            "person": self.person,
            "review": "review"
//            "date": convertedDate
        ]
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addDocument(data: addData)
    }
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
}

extension MakeTargetViewController: DateTargetTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func didTapChangeVisibleButton(cell: DateTargetTableViewCell) {
        if let indexPath = sectionTableView.indexPath(for: cell) {
            data.toggle()
            sectionTableView.reloadRows(at: [indexPath], with: .automatic)
            print(data)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let targetCell = tableView.dequeueReusableCell(withIdentifier: "makeTargetCell") as! MakeTargetTableViewCell
            targetCell.selectionStyle = UITableViewCell.SelectionStyle.none
            return targetCell
        } else if indexPath.section == 1 {
            let importanceCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            importanceCell.selectionStyle = UITableViewCell.SelectionStyle.none
            importanceCell.accessoryType = .none
            return importanceCell
        } else if indexPath.section == 2 {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            detailCell.selectionStyle = UITableViewCell.SelectionStyle.none
            detailCell.titleLabel.text = "詳細"
            detailCell.levelStepper.isHidden = true
            return detailCell
        } else {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateTargetCell") as! DateTargetTableViewCell
            dateCell.selectionStyle = UITableViewCell.SelectionStyle.none
            dateCell.delegate = self
            return dateCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            self.performSegue(withIdentifier: "toQuestion", sender: nil)
            print("画面遷移")
        } else {
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else if indexPath.section == 1 {
            return 50
        } else if indexPath.section == 2 {
            return 50
        } else {
            if data {
                return 380
            } else {
                return 50
            }
            return tableView.estimatedRowHeight
        }
    }
}
