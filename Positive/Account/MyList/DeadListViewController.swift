//
//  DeadListViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/05.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class DeadListViewController: UIViewController {
    
    @IBOutlet weak var deadListCollection: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var addressesDeadLine: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadListCollection.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        deadListCollection.delegate = self
        deadListCollection.dataSource = self
        fetchDeadData()
        design()
    }
    
    private func fetchDeadData() {
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
                self.addressesDeadLine.removeAll()
                print("ここでとる: \(querySnapShot.documents)")
                for doc in querySnapShot.documents {
                    var detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    let deadlineDate = DateFormat.shared.self.dateFormat(date: detailGoal.date.dateValue())
                    let today = DateFormat.shared.self.dateFormat(date: Date())
                    detailGoal.isPassed = true
                    if deadlineDate.compare(today) == .orderedAscending {
                        self.addressesDeadLine.append(detailGoal)
                    }
                }
                self.deadListCollection.reloadData()
                print("目標が表示される")
            }
    }
    
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
    }
}

extension DeadListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressesDeadLine.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        cell.delegate = self
        cell.targetLabel.text = addressesDeadLine[indexPath.row].goal
        let cellDate = addressesDeadLine[indexPath.row].date.dateValue()
        cell.deadLabel.text = DateFormat.shared.dateFormat(date: cellDate)
        cell.deadLabel.textColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.frame.width - 32
        let cellHeight: CGFloat = 80
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let nextNC = storyboard?.instantiateViewController(withIdentifier: "detailTarget") as! TargetDetailViewController
            nextNC.modalTransitionStyle = .coverVertical
            nextNC.modalPresentationStyle = .pageSheet
            nextNC.Goal = addressesDeadLine[indexPath.row].goal
            nextNC.MiniGoal = addressesDeadLine[indexPath.row].nowTodo!
            nextNC.Trigger = addressesDeadLine[indexPath.row].trigger!
            nextNC.EssentialThing = addressesDeadLine[indexPath.row].essentialThing!
            nextNC.DocumentId = addressesDeadLine[indexPath.row].documentID
            nextNC.IsShared = addressesDeadLine[indexPath.row].isShared ?? true
            nextNC.userName = addressesDeadLine[indexPath.row].iineUsers
            navigationController?.pushViewController(nextNC, animated: true)
    }
}

extension DeadListViewController: ListCollectionDelegate {
    func tappedDelete(cell: ListCollectionViewCell) {
        AlertDialog.shared.showAlert(title: "目標を削除しますか？", message: "", viewController: self) {
            delete()
        }
        
        func delete() {
            guard let user = user else {return}
            if let indexPath = deadListCollection.indexPath(for: cell){
                let documentId = addressesDeadLine[indexPath.row].documentID
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
                self.addressesDeadLine.remove(at: indexPath.row)
                deadListCollection.reloadData()
            }
        }
    }
}
