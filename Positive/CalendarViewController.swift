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
    var addressesReview: [Review] = []         //振り返りデータを格納
    var applicableData: [DetailGoal] = []         //addressesにフィルターをかけたものを格納
    var segmentState: SegmentState? = .record
    var viewWidth: CGFloat = 0.0
    var applicableDataReview: [Review] = []              //日付フィルターをかけた振り返りデータ
    var startingFrame : CGRect!
    var endingFrame : CGRect!
    var datesWithEvents: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewButton.isHidden = false
        calendarView.select(Date())
        calendarView.scope = .month
        calendarView.textInputMode?.accessibilityFrame.size
        reportCollectionView.dataSource = self
        reportCollectionView.delegate = self
        reportCollectionView.register(UINib(nibName: "CalendarTargetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reportCell")
        viewWidth = view.frame.width
        print(data)
        configureSizes()
        fetchDataTarget()
        fetchDataReview()
        reportCollectionView.reloadData()
        design()
    }
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    private func fetchDataTarget(){
        guard let user = user else {
            return
        }
        guard let selectedDate = calendarView.selectedDate else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                self.addresses.removeAll()
                for doc in querySnapshot.documents{
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    self.addresses.append(detailGoal)
                }
                if self.dateFormat(date: selectedDate) == self.dateFormat(date: Date()){
                    self.filteringData(date: selectedDate)
                }
                self.reportCollectionView.reloadData()
            }
    }
    
    private func fetchDataReview(){
        guard let user = user else {
            return
        }
        guard let calendarDate = calendarView.selectedDate else {
            return
        }
        guard let selectedDate = calendarView.selectedDate else {
            return
        }
        print("date: \(Timestamp(date: calendarDate))")
        db.collection("users")
            .document(user.uid)
            .collection("reviews")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                self.addressesReview.removeAll()
                for doc in querySnapshot.documents{
                    let review = Review(dictionary: doc.data())
                    self.addressesReview.append(review)
                    print("addressesReview: \(self.addressesReview)")
                }
                if self.dateFormat(date: selectedDate) == self.dateFormat(date: Date()){
                    self.filteringData(date: selectedDate)
                }
                self.reportCollectionView.reloadData()
            }
    }
    
    @IBAction func toReviewViewButton() {
        let storyboard: UIStoryboard = self.storyboard!
        let nc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        let nextNC = nc.viewControllers[0] as! ReviewViewController
        nextNC.calendarSelectedDate = self.calendarView.selectedDate
        let deadLineData = addresses.filter { data in
            let converteDate = dateFormat(date: data.date.dateValue())
            let calendarDate = dateFormat(date: calendarView.selectedDate!)
            return converteDate.compare(calendarDate) == .orderedDescending || converteDate.compare(calendarDate) == .orderedSame
        }
        if deadLineData.isEmpty {
            AlertDialog.shared.showAlert(title: "目標の設定がありません", message: "Home画面で目標を設定してください", viewController: self) {
                print("empty Array:\(self.addressesReview)")
            }
            return
        }
        nextNC.deadlineData = deadLineData
        self.present(nc, animated: true, completion: nil)
    }
    
    @IBAction func tapSegmentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            reviewButton.isHidden = false
            segmentState = .record
            reportCollectionView.reloadData()
            break
        case 1:
            reviewButton.isHidden = true
            segmentState = .affirmation
            reportCollectionView.reloadData()
            break
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.reviewButton.isHidden {
            self.reviewButton.isHidden = false
            self.reviewButton.frame = startingFrame
            UIView.animate(withDuration: 1.0) {
                self.reviewButton.frame = self.endingFrame
            }
        }
    }
    
    private func configureSizes() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
    }
    
    private func filteringData(date: Date){
        let calendarDate = dateFormat(date: date)
        applicableData.removeAll()
        applicableData = addresses.filter({data in
            let converteDate = dateFormat(date: data.date.dateValue())
            let calendarDate = dateFormat(date: calendarView.selectedDate!)
            let startDate = dateFormat(date: data.createdAt.dateValue())
            return (converteDate.compare(calendarDate) == .orderedDescending || converteDate.compare(calendarDate) == .orderedSame) && (startDate.compare( calendarDate) == .orderedAscending || startDate.compare(calendarDate) == .orderedSame)
        })
        applicableDataReview.removeAll()
        applicableDataReview = addressesReview.filter({ data in
            let convertedDate = dateFormat(date: data.date.dateValue())
            return calendarDate == convertedDate
        })
        print("addressesCount: \(addresses.count)")
        print("applicableDataCount: \(applicableData.count)")
        reportCollectionView.reloadData()
    }
    
    func design() {
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
        switch segmentState{
        case .affirmation:
            return applicableData.count
        case .record:
            return applicableDataReview.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reportCell", for: indexPath) as! CalendarTargetCollectionViewCell
        cell.layer.cornerRadius = 13
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
//        cell.bigTargetLabel.text = applicableData[indexPath.row].goal
        
        switch segmentState {
        case .affirmation:
            cell.bigTargetLabel.text = applicableData[indexPath.row].goal
            cell.miniTargetLabel.text = applicableData[indexPath.row].nowTodo
            cell.textLabel.text = "ミニ目標"
            break
        case .record:
            cell.bigTargetLabel.text = applicableDataReview[indexPath.row].targetGoal
            cell.miniTargetLabel.text = applicableDataReview[indexPath.row].original
//            cell.miniTargetLabel.text = applicableDataReview[indexPath.row].reframing
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
    
    enum SegmentState{
        case record
        case affirmation
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
            let calendarDate = dateFormat(date: calendarView.selectedDate!)
            let startDate = dateFormat(date: data.createdAt.dateValue())
            return (convertedDate.compare(calendarDate) == .orderedDescending || convertedDate.compare(calendarDate) == .orderedSame) && (startDate.compare(calendarDate) == .orderedAscending || startDate.compare(calendarDate) == .orderedSame)
        })
        applicableDataReview.removeAll()
        applicableDataReview = addressesReview.filter({ data in
            let convertedDate = dateFormat(date: data.date.dateValue())
            return calendarDate == convertedDate
        })
        reportCollectionView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return applicableData.count
    }
}
