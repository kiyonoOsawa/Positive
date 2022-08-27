//
//  AccountViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/15.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Charts

class AccountViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var chartBack1: UIView!
    @IBOutlet weak var chartBack2: UIView!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var friendsCollection: UICollectionView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var addresses: [[String : Any]] = []
    let rawDataGraph: [Int] = [130, 240, 500, 550, 670, 800, 950, 1300, 1400, 1500, 1700, 2100, 2500, 3600, 4200, 4300, 4700, 4800, 5400, 5800, 5900, 6700]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsCollection.dataSource = self
        friendsCollection.delegate = self
        friendsCollection.register(UINib(nibName: "FriendAccCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "accCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 横スクロール
        friendsCollection.collectionViewLayout = layout
        fetchData()
        design()
    }
    
    private func fetchData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    return
                }
                guard let data = querySnapshot.data() else {
                    return
                }
                
                self.nameLabel.text = data["name"] as! String
            }
    }
    
    func design() {
        chartBack1.layer.cornerRadius = 20
        chartBack1.layer.shadowColor = UIColor.black.cgColor
        chartBack1.layer.shadowOpacity = 0.25
        chartBack1.layer.shadowOffset = CGSize(width: 0, height: 0)
        chartBack1.layer.masksToBounds = false
        chartBack2.layer.cornerRadius = 20
        chartBack2.layer.shadowColor = UIColor.black.cgColor
        chartBack2.layer.shadowOpacity = 0.25
        chartBack2.layer.shadowOffset = CGSize(width: 0, height: 0)
        chartBack2.layer.masksToBounds = false
        friendsBack.layer.cornerRadius = 20
        friendsBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        friendsCollection.register(UINib(nibName: "FriendAccCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "accCell")
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accCell", for: indexPath) as! FriendAccCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 72
        let cellHeight: CGFloat = 100
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
    }
}



