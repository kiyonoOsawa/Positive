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

enum SegmentState {
    case affirmation
    case record
}

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var reportCollectionView: UICollectionView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    
    var data: [Bool] = []
    let fsCalendar = FSCalendar()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var goal: String = ""
    var addresses: [DetailGoal] = []
    var applicableData: [DetailGoal] = []         //addressesにフィルターをかけたものを格納
    var segmentState: SegmentState? = .affirmation
    var viewWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scope = .month
        calendarView.textInputMode?.accessibilityFrame.size
        reportCollectionView.dataSource = self
        reportCollectionView.delegate = self
        reportCollectionView.register(UINib(nibName: "CalendarTargetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reportCell")
        viewWidth = view.frame.width
        print(data)
        fetchData()
        design()
    }
    
    private func fetchData(){
        guard let user = user else {
            return
        }
        self.addresses.removeAll()
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                for doc in querySnapshot.documents{
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    self.addresses.append(detailGoal)
                }
                self.reportCollectionView.reloadData()
            }
    }
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func toReviewView() {
        self.performSegue(withIdentifier: "toAddReview", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddReview" {
            let nextVC = segue.destination as! ReviewViewController
            let deadlineData = addresses.filter { data in
                let convertedDate = dateFormat(date: data.date.dateValue())
                let calendarDate = dateFormat(date: calendarView.selectedDate!)
                return convertedDate.compare(calendarDate) == .orderedAscending || convertedDate.compare(calendarDate) == .orderedSame
            }
//            nextVC.deadlineD
        }
    }
    
    @IBAction func tapSegmentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            reviewButton.isHidden = true
            segmentState = .affirmation
            reportCollectionView.reloadData()
            break
        case 1:
            reviewButton.isHidden = false
            segmentState = .record
            reportCollectionView.reloadData()
            break
        default:
            break
        }
    }
    
    func design() {
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        reviewButton.layer.cornerRadius = 32
        reviewButton.layer.shadowColor = UIColor.black.cgColor
        reviewButton.layer.shadowOpacity = 0.15
        reviewButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        reviewButton.layer.masksToBounds = false
        reviewButton.imageView?.contentMode = .scaleAspectFill
        reviewButton.contentHorizontalAlignment = .fill
        reviewButton.contentVerticalAlignment = .fill
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return 1
        return applicableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportCell", for: indexPath) as! CalendarTargetCollectionViewCell
        cell.layer.cornerRadius = 13
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        cell.bigTargetLabel.text = applicableData[indexPath.row].goal
        switch segmentState {
        case .affirmation:
            cell.miniTargetLabel.text = applicableData[indexPath.row].essentialThing
            break
        case .record:
            cell.miniTargetLabel.text = applicableData[indexPath.row].review
            if cell.miniTargetLabel.text == nil {
                cell.textLabel.text = ""
            } else {
                cell.textLabel.text = "振り返り"
            }
            break
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 32
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 98
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendarDate = dateFormat(date: date)
        applicableData.removeAll()
        applicableData = addresses.filter({data in
            let convertedDate = dateFormat(date: data.date.dateValue())
            return calendarDate == convertedDate
        })
        reportCollectionView.reloadData()
    }
}
