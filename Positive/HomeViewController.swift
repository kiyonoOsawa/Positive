//
//  HomeViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    @IBOutlet weak var targetCollection: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var friendTargetCollection: UICollectionView!
    @IBOutlet weak var backView: UIView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var viewWidth: CGFloat = 0.0
    var addresses: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetCollection.delegate = self
        targetCollection.dataSource = self
        friendTargetCollection.delegate = self
        friendTargetCollection.dataSource = self
        targetCollection.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "targetHome")
        friendTargetCollection.register(UINib(nibName: "FriendsInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendsTarget")
        design()
    }
    
    private func fetchData() {
        guard let user = user else {
            return
        }
        self.addresses.removeAll()
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapShot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                for doc in querySnapShot.documents {
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    self.addresses.append(detailGoal)
                }
                self.friendTargetCollection.reloadData()
            }
    }
    
    func design() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "targetHome", for: indexPath) as! InnerCollectionViewCell
            cell.layer.cornerRadius = 15
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.masksToBounds = false
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsTarget", for: indexPath) as! FriendsInnerCollectionViewCell
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let cellWidth: CGFloat = 304
            let cellHeight: CGFloat = 304
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let space: CGFloat = 11
            let cellWidth: CGFloat = viewWidth - space
            let cellHeight: CGFloat = 98104
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 40
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
