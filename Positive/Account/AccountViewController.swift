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
import SwiftUI

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chartBack: UIView!
//    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var aveLabel: UILabel!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var friendsCollection: UICollectionView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://taffi-f610f.appspot.com/")
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var addresses: [DetailGoal] = []
    var friends: User? = nil
    var addressesFriends: [DetailGoal] = []
    var accountList: [User] = []
    var rawDataGraph: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsCollection.dataSource = self
        friendsCollection.delegate = self
        friendsCollection.register(UINib(nibName: "FriendAccCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "accCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 横スクロール
        friendsCollection.collectionViewLayout = layout
        fetchMyData()
        fetchReviewData()
        design()
    }
    
    private func fetchMyData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .addSnapshotListener { DocumentSnapshot, Error in
                guard let documentSnapshot = DocumentSnapshot else { return }
                guard let data = documentSnapshot.data() else { return }
                let myAccount = User(userData: data)
                self.nameLabel.text = myAccount.userName
                self.fetchFriendList(friendList: myAccount.friendList ?? [""])
            }
        let imagesRef = self.storageRef.child("userProfile").child("\(user.uid).jpg")
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, Error in
            if let Error = Error {
                print("画像の取り出しに失敗: \(Error)")
            } else {
                let image = UIImage(data: data!)
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.clipsToBounds = true
                self.imageView.image = image
            }
        }
    }
    
    private func fetchFriendList(friendList: [String]) {
        db.collection("users")
            .whereField("userId", in: friendList)
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    print("Error: \(Error.debugDescription)")
                    return
                }
                self.accountList.removeAll()
                for doc in querySnapshot.documents {
                    let account = User(userData: doc.data())
                    self.accountList.append(account)
                }
                self.friendsCollection.reloadData()
            }
    }
    
    private func fetchReviewData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .collection("reviews")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else { return }
                self.rawDataGraph.removeAll()
                for doc in querySnapshot.documents {
                    let review = Review(dictionary: doc.data(), reviewDocumentId: doc.documentID)
                    self.rawDataGraph.append(Int(review.score ?? 0))
//                    let entries = self.rawDataGraph.enumerated().map { ChartDataEntry(x: Double($0.offset),y: Double($0.element))}
//                    self.setChartData(entries: entries)
                    self.setAverageData(scores: self.rawDataGraph)
                }
            }
    }
    
//    private func setChartData(entries: [ChartDataEntry]) {
//        let dataSet = LineChartDataSet(entries: entries)
//        self.lineChartView.data = LineChartData(dataSet: dataSet)
//    }
    
    private func setAverageData(scores: [Int]) {
        let average = scores.reduce(0, +) / scores.count
        aveLabel.text = String(average)
    }
    
    func design() {
        imageView.layer.cornerRadius = 36
        editButton.layer.cornerRadius = 12
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        chartBack.layer.cornerRadius = 20
        chartBack.layer.shadowColor = UIColor.black.cgColor
        chartBack.layer.shadowOpacity = 0.25
        chartBack.layer.shadowOffset = CGSize(width: 0, height: 0)
        chartBack.layer.masksToBounds = false
        friendsBack.layer.cornerRadius = 20
        friendsBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accCell", for: indexPath) as! FriendAccCollectionViewCell
        cell.friendIcon.layer.cornerRadius = 36
        let friendId: String = accountList[indexPath.row].userId ?? ""
        cell.friendName.text = accountList[indexPath.row].userName
        let imagesRef = self.storageRef.child("userProfile").child("\(friendId).jpg")
        let indicator = ActivityIndicator.shared
        indicator.showIndicator(view: view)
        indicator.activityIndicatorView.startAnimating()
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("画像の取り出しに失敗: \(error)")
            }else{
                let image = UIImage(data: data!)
                cell.friendIcon.contentMode = .scaleAspectFill
                cell.friendIcon.clipsToBounds = true
                cell.friendIcon.image = image
                indicator.activityIndicatorView.stopAnimating()
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 72
        let cellHeight: CGFloat = 120
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
}

//private extension AccountViewController{
//    @available(iOS 16.0, *)
//    func hostingGraphView(){
//        let chartView = LineChartView(graphViewModel: GraphViewModel)
//        let controller = UIHostingController(rootView: chartView)
//        addChild(controller)
//        chartBack.addSubview(controller.view)
//        controller.didMove(toParent: self)
//        controller.view?.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        controller.view?.leftAnchor.constraint(equalTo: self.chartBack.leftAnchor, constant: 50).isActive = true
//        controller.view?.rightAnchor.constraint(equalTo: self.chartBack.rightAnchor, constant: 50).isActive = true
//        controller.view?.centerYAnchor.constraint(equalTo: self.chartBack.centerYAnchor).isActive = true
//    }
//}
