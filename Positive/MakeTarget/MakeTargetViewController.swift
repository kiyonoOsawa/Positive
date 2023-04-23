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
    var userName = String()
    var data: Bool = false
    var addData: [String: Any] = [:]
    var targetCell = MakeTargetTableViewCell()
    var detailCell = ImportanceTableViewCell()
    var shareCell = ImportanceTableViewCell()
    var nowTodo = String()
    var essentialThing = String()
    var trigger = String()
    var person = String()
    var dateCell: DateTargetTableViewCell!
    var date = Date()
    var isShared: Bool = true
    var isDoneTarget: Bool = false
    var transferViewModel = TransferValue.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTableView.register(UINib(nibName: "MakeTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "makeTargetCell")
        sectionTableView.register(UINib(nibName: "ImportanceTableViewCell", bundle: nil), forCellReuseIdentifier: "importanceCell")
        sectionTableView.register(UINib(nibName: "DateTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "dateTargetCell")
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
        transferViewModel.resetValue()
        design()
        fetchFiendName()
        setDismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nowTodo = transferViewModel.eachAnswer[0]
        self.essentialThing = transferViewModel.eachAnswer[1]
        self.trigger = transferViewModel.eachAnswer[2]
    }
    
    @IBAction func tappedSaveButton() {
        let user = Auth.auth().currentUser
        if user == nil {
            addQuestion()
        } else {
            print("保存したよん")
            self.dismiss(animated: true)
            addQuestion()
        }

    }
    
    @IBAction func backView() {
        self.dismiss(animated: true)
    }
    
    private func fetchFiendName() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .addSnapshotListener { DocumentSnapshot, Error in
                guard let documentSnapshot = DocumentSnapshot else {
                    return
                }
                guard let data = documentSnapshot.data() else { return }
                let user = User(userData: data)
                self.userName = user.userName ?? ""
                print("userName: \(self.userName)")
            }
    }
    
    private func addQuestion() {
        guard let user = user else {
            if user == nil {
                let storyboard : UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
                let nextVC = storyboard.instantiateViewController(withIdentifier: "firstAccView")
                self.present(nextVC, animated: true, completion: nil)
            } else {
                return
            }
            return
        }
        if data == true {
            date = dateCell.datePicker.date
        }
        let convertedDate = Timestamp(date: date)
        let addData: [String:Any] = [
            "goal": targetCell.targetTextField.text ?? "",
            "nowTodo": self.nowTodo,
            "essentialThing": self.essentialThing,
            "trigger": self.trigger,
            "person": self.person,
            "review": "review",
            "date": convertedDate,
            "userId": user.uid,
            "userName": userName,
            "createdAt": Timestamp(date: Date()),
            "isShared": isShared,
            "isDoneTarget": isDoneTarget
        ]
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addDocument(data: addData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestion"{
            let vc = segue.destination as! QuestionViewController
            vc.eachAnswer[0] = self.nowTodo
            vc.eachAnswer[1] = self.essentialThing
            vc.eachAnswer[2] = self.trigger
        }
    }
    
    func design() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "目標設定"
        
    }
}

extension MakeTargetViewController: DateTargetTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func didTapChangeVisibleButton(cell: DateTargetTableViewCell) {
        if let indexPath = sectionTableView.indexPath(for: cell) {
            date = cell.datePicker.date
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
            targetCell = tableView.dequeueReusableCell(withIdentifier: "makeTargetCell") as! MakeTargetTableViewCell
            targetCell.selectionStyle = UITableViewCell.SelectionStyle.none
            return targetCell
        } else if indexPath.section == 1 {
            shareCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            shareCell.selectionStyle = UITableViewCell.SelectionStyle.none
            shareCell.accessoryType = .none
            shareCell.delegate = self
            return shareCell
        } else if indexPath.section == 2 {
            detailCell = tableView.dequeueReusableCell(withIdentifier: "importanceCell") as! ImportanceTableViewCell
            detailCell.selectionStyle = UITableViewCell.SelectionStyle.none
            detailCell.titleLabel.text = "詳細"
            detailCell.shareSwitch.isHidden = true
            return detailCell
        } else {
            dateCell = tableView.dequeueReusableCell(withIdentifier: "dateTargetCell") as! DateTargetTableViewCell
            dateCell.selectionStyle = UITableViewCell.SelectionStyle.none
            dateCell.dateLabel.isHidden = true
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
        if indexPath.section == 3 {
            if data {
                return 380
            } else {
                return 50
            }
        } else {
            return 50
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

extension MakeTargetViewController: ImportanceCellDelegate{
    func onSwitch(cell: ImportanceTableViewCell) {
        self.isShared = true
    }
    
    func offSwitch(cell: ImportanceTableViewCell) {
        self.isShared = false
    }
}
