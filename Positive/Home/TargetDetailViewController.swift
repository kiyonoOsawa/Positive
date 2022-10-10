//
//  TargetDetailViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/26.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TargetDetailViewController: UIViewController {
    
    @IBOutlet weak var targetTextView: UITextView!
    @IBOutlet weak var miniTargetTextView: UITextView!
    @IBOutlet weak var essentialTextView: UITextView!
    @IBOutlet weak var triggerTextView: UITextView!
    @IBOutlet weak var setTabelView: UITableView!
    @IBOutlet weak var iineTextView: UITextView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var addresses: [DetailGoal] = []
    var data: Bool = false
    var date = Date()
    var shareCell = ImportanceTableViewCell()
    var dateCell = DateTargetTableViewCell()
    var Goal = String()
    var MiniGoal = String()
    var Trigger = String()
    var EssentialThing = String()
    var DocumentId = String()
    var IsShared = Bool()
    var userName: [String] = []
    var deadDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabelView.delegate = self
        setTabelView.dataSource = self
        setTabelView.register(UINib(nibName: "DateTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "dateTargetCell")
        setTabelView.register(UINib(nibName: "ImportanceTableViewCell", bundle: nil), forCellReuseIdentifier: "importanceCell")
        design()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSave() {
        updateGoal()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateGoal() {
        guard let user = user else {
            return
        }
        if data == true {
            date = dateCell.datePicker.date
        }
        let convertedDate = Timestamp(date: date)
        let updateGoal: [String:Any] = [
            "goal": self.targetTextView.text!,
            "nowTodo": self.miniTargetTextView.text!,
            "date": convertedDate,
            "isShared": IsShared,
            "essentialThing": essentialTextView.text!,
            "trigger": triggerTextView.text!
        ]
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .document(DocumentId)
            .updateData(updateGoal)
    }

    func design() {
        targetTextView.text = Goal
        miniTargetTextView.text = MiniGoal
        essentialTextView.text = EssentialThing
        triggerTextView.text = Trigger
        iineTextView.isEditable = false
        var string = ""
        userName.forEach { user in
            string += "＠\(user) "
        }
        if !userName.isEmpty{
            iineTextView.text = "\(string)が応援しています"
        } else {
            iineTextView.text = "まだいません"
        }
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.targetTextView.isFirstResponder) {
            self.targetTextView.resignFirstResponder()
        } else if (self.miniTargetTextView.isFirstResponder) {
            self.miniTargetTextView.resignFirstResponder()
        } else if (self.essentialTextView.isFirstResponder) {
            self.essentialTextView.resignFirstResponder()
        } else if (self.triggerTextView.isFirstResponder) {
            self.triggerTextView.resignFirstResponder()
        }
    }
    
}

extension TargetDetailViewController: DateTargetTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            shareCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            shareCell.selectionStyle = UITableViewCell.SelectionStyle.none
            shareCell.accessoryType = .none
            shareCell.shareSwitch.isOn = IsShared
            shareCell.delegate = self
            return shareCell
        } else {
            dateCell = tableView.dequeueReusableCell(withIdentifier: "dateTargetCell") as! DateTargetTableViewCell
            dateCell.selectionStyle = UITableViewCell.SelectionStyle.none
            dateCell.delegate = self
            dateCell.datePicker.date = deadDate
            dateCell.dateLabel.text = DateFormat.shared.dateFormat(date: deadDate)
            return dateCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func didTapChangeVisibleButton(cell: DateTargetTableViewCell) {
        if let indexPath = setTabelView.indexPath(for: cell) {
            date = cell.datePicker.date
            data.toggle()
            setTabelView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
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

extension TargetDetailViewController: ImportanceCellDelegate{
    func onSwitch(cell: ImportanceTableViewCell) {
        self.IsShared = true
    }
    
    func offSwitch(cell: ImportanceTableViewCell) {
        self.IsShared = false
    }
}
