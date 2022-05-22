//
//  CalendarViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit
import FSCalendar
import Firebase

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    var data: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        calendarView.scope = .week
        calendarView.textInputMode?.accessibilityFrame.size
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ReportTableViewCell
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if data {
                print("伸び縮み")
                return 380
            } else {
                return 44
            }
        }
        return tableView.estimatedRowHeight
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendarHeight.constant = bounds.height
            self.view.layoutIfNeeded()
    }

}
extension CalendarViewController: CellExtendDelegate {
    
    func didExtendButton(cell: ReportTableViewCell) {
        if let indexPath = reportTableView.indexPath(for: cell){
            data.toggle()
            reportTableView.reloadRows(at: [indexPath], with: .automatic)
            print(data)
        }
    }
    
}
