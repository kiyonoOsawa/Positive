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
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var miniTargetTextView: UITextView!
    @IBOutlet weak var essentialTextView: UITextView!
    @IBOutlet weak var triggerTextView: UITextView!
    @IBOutlet weak var personTextView: UITextView!
    @IBOutlet weak var setTabelView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
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
    var Person = String()
    var EssentialThing = String()
    var DocumentId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabelView.delegate = self
        setTabelView.dataSource = self
        setTabelView.register(UINib(nibName: "DateTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "dateTargetCell")
        setTabelView.register(UINib(nibName: "ImportanceTableViewCell", bundle: nil), forCellReuseIdentifier: "importanceCell")
//        fetchData()
        design()
    }
    
//    func fetchData() {
//        guard let user = user else {
//            return
//        }
//        self.addresses.removeAll()
//        db.collection("users")
//            .document(user.uid)
//            .collection("goals")
//            .addSnapshotListener{ QuerySnapshot, Error in
//                guard let querySnapshot = QuerySnapshot else {
//                    return
//                }
////                guard let data = documentSnapshot.data() else { return }
////                let myAccount = User(userData: data)
////                self.nameField.text = myAccount.userName
////                self.emailField.text = user.email
//
//                for doc in querySnapshot.documents {
//                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
//                    self.addresses.append(detailGoal)
//                }
//            }
//    }
    
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
            "nowTodo": self.miniTargetTextView.text!,
            "date": convertedDate
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
        targetLabel.text = Goal
        miniTargetTextView.text = MiniGoal
        essentialTextView.text = EssentialThing
        triggerTextView.text = Trigger
        personTextView.text = Person
        let mainColor = UIColor(named: "MainColor")
        guard let mainColor = mainColor else { return }
        saveButton.layer.cornerRadius = 15
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = mainColor.cgColor
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
