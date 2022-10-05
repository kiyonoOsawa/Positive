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
    var addressesDeadLine: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listCollection.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        listCollection.delegate = self
        listCollection.dataSource = self
        fetchData()
        fetchDeadData()
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
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    let deadlineDate = DateFormat.shared.self.dateFormat(date: detailGoal.date.dateValue())
                    let today = DateFormat.shared.self.dateFormat(date: Date())
                    if deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending{
                        self.addresses.append(detailGoal)
                    }
                }
                self.listCollection.reloadData()
                print("目標が表示される")
            }
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
                self.listCollection.reloadData()
                print("目標が表示される")
            }
    }
    
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        cell.targetLabel.text = addresses[indexPath.row].goal
        let cellDate = addresses[indexPath.row].date.dateValue()
        let viewDate = DateFormat.shared.dateFormat(date: cellDate)
        cell.deadLabel.text = viewDate
        let cellDeadDate = addressesDeadLine[indexPath.row].date.dateValue()
        cell.deadLabel.text = DateFormat.shared.dateFormat(date: cellDeadDate)
        if addresses[indexPath.row].isShared == true {
            cell.deadLabel.tintColor = .red
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.frame.width - 16
        let cellHeight: CGFloat = 98
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
    }
}
