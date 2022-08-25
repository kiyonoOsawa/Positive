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
    @IBOutlet weak var friendTargetCollection: UICollectionView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var friendsBack: UIView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var viewWidth: CGFloat = 366
    var addresses: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("friendsBackの横幅")
        print(friendsBack.frame.width)
        self.dismiss(animated: true, completion: nil)
        targetCollection.delegate = self
        targetCollection.dataSource = self
        friendTargetCollection.delegate = self
        friendTargetCollection.dataSource = self
        targetCollection.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "targetHome")
        friendTargetCollection.register(UINib(nibName: "FriendsInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendsTarget")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 横スクロール
        targetCollection.collectionViewLayout = layout
        design()
        fetchData()
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
                print("ここでとる: \(querySnapShot.documents)")
                for doc in querySnapShot.documents {
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    self.addresses.append(detailGoal)
                }
                self.targetCollection.reloadData()
                self.friendTargetCollection.reloadData()
            }
    }
    
    func design() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //        backView.layer.cornerRadius = 20
        //        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        targetCollection.layer.cornerRadius = 25
        targetCollection.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        friendsBack.layer.cornerRadius = 25
        friendsBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return addresses.count
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "targetHome", for: indexPath) as! InnerCollectionViewCell
            cell.layer.cornerRadius = 15
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.masksToBounds = false
            cell.goalLabel.text = addresses[indexPath.row].goal
            cell.miniGoal1.text = addresses[indexPath.row].nowTodo
//            cell.stepView = UIImage.image
            cell.reviewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsTarget", for: indexPath) as! FriendsInnerCollectionViewCell
            //            cell.layer.cornerRadius = 20
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let cellWidth: CGFloat = 304
            let cellHeight: CGFloat = 304
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let space: CGFloat = 10
            let cellWidth: CGFloat = friendTargetCollection.frame.width - space
            let cellHeight: CGFloat = 104
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 12, left:38, bottom: 0, right: 38)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    @objc func buttonTapped(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
