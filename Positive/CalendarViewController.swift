//
//  CalendarViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit
import FSCalendar
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    var data: [Bool] = []
    let fsCalendar = FSCalendar()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var goal: String = ""
    fileprivate let cellHeight: CGFloat = 30
    fileprivate let numberOfCells: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        calendarView.scope = .week
        calendarView.textInputMode?.accessibilityFrame.size
        for _ in 0...4 {
            data.append(false)
        }
        saved()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendarHeight.constant = bounds.height
            self.view.layoutIfNeeded()
    }
    
    func saved() {
        guard let user = user else {
            return
        }
        let addData:[String:Any] = [
            "goal": goal
        ]
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addDocument(data: addData)
    }

}
extension CalendarViewController: CellExtendDelegate,UITableViewDelegate, UITableViewDataSource  {
    
    func didExtendButton(cell: ReportTableViewCell) {
        if let indexPath = reportTableView.indexPath(for: cell){
            data[indexPath.row].toggle()
            reportTableView.reloadRows(at: [indexPath], with: .automatic)
            print(data)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "targetCell") as! ReportTableViewCell
//        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if data[indexPath.row] {
                print("伸び縮み")
                return 200
            } else {
                return 50
            }
        }
        return cellHeight
    }
}
