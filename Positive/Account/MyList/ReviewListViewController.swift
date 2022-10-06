//
//  ReviewListViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/06.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ReviewListViewController: UIViewController {
    
    @IBOutlet weak var reviewListCollection: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var addressesReview: [Review] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewListCollection.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
        reviewListCollection.delegate = self
        reviewListCollection.dataSource = self
        fetchData()
        design()
    }
    
    func fetchData() {
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
                self.reviewListCollection.reloadData()
                print("目標が表示される")
            }
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
    }

}

extension ReviewListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressesReview.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        cell.delegate = self
        if addressesReview[indexPath.row].reframing == nil {
            cell.targetLabel.text = addressesReview[indexPath.row].original
        } else {
            cell.targetLabel.text = addressesReview[indexPath.row].reframing
        }
        let cellDate = addressesReview[indexPath.row].date.dateValue()
        cell.deadLabel.text = DateFormat.shared.dateFormat(date: cellDate)
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
}

extension ReviewListViewController: ListCollectionDelegate {
    func tappedDelete(cell: ListCollectionViewCell) {
        AlertDialog.shared.showAlert(title: "振り返りを削除しますか？", message: "", viewController: self) {
            guard let user = self.user else {return}
            if let indexPath = self.reviewListCollection.indexPath(for: cell){
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
                self.reviewListCollection.reloadData()
            }
        }
    }
}
