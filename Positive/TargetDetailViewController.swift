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
//    @IBOutlet weak var saveButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabelView.delegate = self
        setTabelView.dataSource = self
        setTabelView.register(UINib(nibName: "DateTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "dateTargetCell")
        setTabelView.register(UINib(nibName: "ImportanceTableViewCell", bundle: nil), forCellReuseIdentifier: "importanceCell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back))
        design()
        dismissKeyboard()
    }
    
    @objc private func back() {
        self.dismiss(animated: true)
    }
    
    @IBAction func tappedSave() {
        updateGoal()
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
            "isShared": IsShared
        ]
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .document(DocumentId)
            .updateData(updateGoal)
        self.transition()
    }
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func transition() {
        self.dismiss(animated: true)
    }
    func design() {
        targetTextView.text = Goal
        miniTargetTextView.text = MiniGoal
        essentialTextView.text = EssentialThing
        triggerTextView.text = Trigger
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
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
