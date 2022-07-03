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
    var addData: [String: Any] = [:]
    var targetCell: MakeTargetTableViewCell!
    var importanceCell: ImportanceTableViewCell!
    var detailCell: ImportanceTableViewCell!
    var dateCell: DateTargetTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTableView.register(UINib(nibName: "MakeTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "makeTargetCell")
        sectionTableView.register(UINib(nibName: "ImportanceTableViewCell", bundle: nil), forCellReuseIdentifier: "importanceCell")
        sectionTableView.register(UINib(nibName: "DateTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "dateTargetCell")
        sectionTableView.delegate = self
        sectionTableView.dataSource = self
        navigationItem.title = "New Goal"
    }
    
    @IBAction func tappedSaveButton() {
        addData = ["goal": targetCell.targetTextField.text,
                   "importance": importanceCell.levelStepper.value,
                   "date": Timestamp(date: dateCell.datePicker.date)
        ]
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addDocument(data: addData)
    }
}

extension MakeTargetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let targetCell = tableView.dequeueReusableCell(withIdentifier: "makeTargetCell") as! MakeTargetTableViewCell
            return targetCell
        } else if indexPath.section == 1 {
            let importanceCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            importanceCell.accessoryType = .none
            return importanceCell
        } else if indexPath.section == 2 {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            detailCell.titleLabel.text = "詳細"
            detailCell.levelStepper.isHidden = true
            return detailCell
        } else {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "dateTargetCell") as! DateTargetTableViewCell
            return dateCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            self.performSegue(withIdentifier: "toQuestion", sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            return 50
        } else if indexPath.section == 2 {
            return 50
        } else {
            return 380
        }
    }
}
