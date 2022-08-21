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

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    @IBOutlet weak var targetColection: UICollectionView!
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
        targetColection.delegate = self
        targetColection.dataSource = self
        friendTargetCollection.delegate = self
        friendTargetCollection.dataSource = self
        targetColection.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "targetHome")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "targetHome", for: indexPath) as! InnerCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        return cell
        let friendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsTarget", for: indexPath) as! FriendsInnerCollectionViewCell
        friendCell.layer.cornerRadius = 15
        friendCell.layer.borderWidth = 1
        friendCell.layer.borderColor = UIColor.gray.cgColor
        return friendCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 160
        let cellHeight: CGFloat = 120
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 0)
    }
}

//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 1 {
//            return 3
//        } else {
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let myTarget = tableView.dequeueReusableCell(withIdentifier: "OuterCell") as! MyTargetTableViewCell
//            return myTarget
//        } else if indexPath.section == 1 {
//            if indexPath.row == 0 {
//                let reviewCell = tableView.dequeueReusableCell(withIdentifier: "variusCell") as! HomeTableViewCell
//                reviewCell.selectionStyle = .none
//                reviewCell.titleLabel.text = "Review"
//                return reviewCell
//            } else if indexPath.row == 1 {
//                let levelCell = tableView.dequeueReusableCell(withIdentifier: "variusCell") as! HomeTableViewCell
//                levelCell.selectionStyle = .none
//                levelCell.titleLabel.text = "Level"
//                return levelCell
//            } else {
//                let finishCell = tableView.dequeueReusableCell(withIdentifier: "variusCell") as! HomeTableViewCell
//                finishCell.selectionStyle = .none
//                finishCell.titleLabel.text = "Finish Targets"
//                return finishCell
//            }
//        } else {
//            let friendTarget = tableView.dequeueReusableCell(withIdentifier: "friendsTarget") as! FriendsTargetTableViewCell
//            return friendTarget
//        }
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 320
//        } else if indexPath.section == 2{
//            return 180
//        } else {
//            return 50
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            self.performSegue(withIdentifier: "nextMakeView", sender: nil)
//        } else {
//            return
//        }
//    }
//}
