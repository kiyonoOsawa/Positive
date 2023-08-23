//
//  ListViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/05.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ListViewController: UIViewController {
    
    @IBOutlet weak var listCollection: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var addresses: [DetailGoal] = []
    var addressesReview: [Review] = []
    var viewPattern: ViewPattern? = .allTask
    
    enum ViewPattern{
        case allTask
        case deadList
        case reviewList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listCollection.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        listCollection.delegate = self
        listCollection.dataSource = self
        fetchData()
        fetchReviewData()
        design()
    }
    
    private func fetchData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapShot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                self.addresses.removeAll()
                print("ここでとる: \(querySnapShot.documents)")
                for doc in querySnapShot.documents {
                    var detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    let deadlineDate = DateFormat.shared.self.dateFormat(date: detailGoal.date.dateValue())
                    let today = DateFormat.shared.self.dateFormat(date: Date())
                    switch self.viewPattern{
                    case .allTask:
                        if deadlineDate.compare(today) == .orderedAscending {
                            detailGoal.isPassed = true
                        }
                        self.addresses.append(detailGoal)
                    case .deadList:
                        if deadlineDate.compare(today) == .orderedAscending {
                            detailGoal.isPassed = true
                            self.addresses.append(detailGoal)
                        }
                    default: break
                    }
                }
                self.listCollection.reloadData()
                print("目標が表示される")
            }
    }
    
    func fetchReviewData() {
        guard let user = user else {
            return
        }
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
                    let review = Review(dictionary: doc.data(), reviewDocumentId: doc.documentID)
                    self.addressesReview.append(review)
                    print("addressesReview: \(self.addressesReview)")
                }
                self.listCollection.reloadData()
                print("目標が表示される")
            }
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
        switch viewPattern {
        case .allTask:
            self.navigationItem.title = "すべての目標"
        case .deadList:
            self.navigationItem.title = "期限切れ"
        case .reviewList:
            self.navigationItem.title = "振り返り一覧"
        default:
            break
        }
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewPattern {
        case .allTask:
            return addresses.count
        case .deadList:
            return addresses.count
        case .reviewList:
            return addressesReview.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        cell.layer.cornerRadius = 13
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        cell.delegate = self
        
        switch viewPattern {
        case .allTask:
            cell.targetLabel.text = addresses[indexPath.row].goal
            let cellDate = addresses[indexPath.row].date.dateValue()
            let viewDate = DateFormat.shared.dateFormat(date: cellDate)
            cell.deadLabel.text = viewDate
            if addresses[indexPath.row].isPassed == true {
                cell.deadLabel.textColor = .red
            } else {
                cell.deadLabel.textColor = .black
            }
        case .deadList:
            cell.targetLabel.text = addresses[indexPath.row].goal
            let cellDate = addresses[indexPath.row].date.dateValue()
            cell.deadLabel.text = DateFormat.shared.dateFormat(date: cellDate)
            cell.deadLabel.textColor = .red
        case .reviewList:
            if addressesReview[indexPath.row].reframing == nil {
                cell.targetLabel.text = addressesReview[indexPath.row].original
            } else {
                cell.targetLabel.text = addressesReview[indexPath.row].reframing
            }
            let cellDate = addressesReview[indexPath.row].date.dateValue()
            cell.deadLabel.text = DateFormat.shared.dateFormat(date: cellDate)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 32
        let cellWidth: CGFloat = self.view.frame.width - space
        let cellHeight: CGFloat = 80
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewPattern {
        case .allTask:
            nextData()
        case .deadList:
            nextData()
        case .reviewList:
            break
        default:
            break
        }
        func nextData() {
            let detailStoryboard: UIStoryboard = UIStoryboard(name: "TargetDetailStory", bundle: nil)
            let nextNC = detailStoryboard.instantiateViewController(withIdentifier: "detailTarget") as! TargetDetailViewController
            nextNC.modalTransitionStyle = .coverVertical
            nextNC.modalPresentationStyle = .pageSheet
            nextNC.Goal = addresses[indexPath.row].goal
            nextNC.MiniGoal = addresses[indexPath.row].nowTodo!
            nextNC.Trigger = addresses[indexPath.row].trigger!
            nextNC.EssentialThing = addresses[indexPath.row].essentialThing!
            nextNC.DocumentId = addresses[indexPath.row].documentID
            nextNC.IsShared = addresses[indexPath.row].isShared ?? true
            nextNC.userName = addresses[indexPath.row].iineUsers
            navigationController?.pushViewController(nextNC, animated: true)
        }
    }
}

extension ListViewController: ListCollectionDelegate {
    func tappedDelete(cell: ListCollectionViewCell) {
        let title = cell.targetLabel.text
        guard let title = title else { return }
        switch viewPattern {
        case .allTask:
            AlertDialog.shared.showSaveAlert(title: "\(title) を削除しますか？", message: "", viewController: self) {
                delete()
            }
        case .deadList:
            AlertDialog.shared.showSaveAlert(title: "\(title) を削除しますか？", message: "", viewController: self) {
                delete()
            }
        case .reviewList:
            AlertDialog.shared.showSaveAlert(title: "\(title) を削除しますか？", message: "", viewController: self) {
                deleteReview()
            }
        default:
            break
        }
        
        func delete() {
            guard let user = user else {return}
            if let indexPath = listCollection.indexPath(for: cell){
                let documentId = addresses[indexPath.row].documentID
                db.collection("users")
                    .document(user.uid)
                    .collection("goals")
                    .document(documentId)
                    .delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                self.addresses.remove(at: indexPath.row)
                listCollection.reloadData()
            }
        }
        
        func deleteReview() {
            guard let user = self.user else {return}
            if let indexPath = self.listCollection.indexPath(for: cell){
                let documentId = self.addressesReview[indexPath.row].reviewDocumentId
                self.db.collection("users")
                    .document(user.uid)
                    .collection("reviews")
                    .document(documentId)
                    .delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                self.addressesReview.remove(at: indexPath.row)
                self.listCollection.reloadData()
                
            }
        }
    }
}
