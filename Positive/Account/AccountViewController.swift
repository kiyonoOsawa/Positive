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

@available(iOS 16.0, *)
class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chartBack: UIView!
    @IBOutlet weak var aveLabel: UILabel!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var friendsCollection: UICollectionView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://taffi-f610f.appspot.com/")
    let db = Firestore.firestore()
    let viewModel = GraphViewModel()
    var addresses: [DetailGoal] = []
    var friends: User? = nil
    var addressesFriends: [DetailGoal] = []
    var accountList: [User] = []
    var rawDataGraph: [Int] = []
//    var userData = String()
    
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
        hostingGraphView()
        transfar()
    }
    
    private func transfar() {
        var userData: UserDefaults = UserDefaults.standard
        var nilData = userData.object(forKey: "logout") as! String
        print(nilData)
        if nilData == "userNill" {
            let vc = HomeViewController()
            let rootVC = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
            let navigationController = rootVC?.children as? UINavigationController
            rootVC?.selectedIndex = 0
            navigationController?.pushViewController(vc, animated: false)
            return
        } else {
            return
        }
    }
    
    private func fetchMyData() {
        let user = Auth.auth().currentUser
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
//        let user = Auth.auth().currentUser
//        guard let user = user else {
//            addressesFriends = []
//            self.friendsCollection.reloadData()
//            return
//        }
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
        let user = Auth.auth().currentUser
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
                    self.viewModel.update(value: review.score, number: Double(self.rawDataGraph.count - 1))
                    self.setAverageData(scores: self.rawDataGraph)
                }
            }
    }
    
    private func setAverageData(scores: [Int]) {
        let average = scores.reduce(0, +) / scores.count
        aveLabel.text = String(average)
    }
    
    @IBAction func toEditView() {
        let storyboard : UIStoryboard = UIStoryboard(name: "AccountStory", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "editAccView")
        self.present(nextVC, animated: true, completion: nil)
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

@available(iOS 16.0, *)
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
                indicator.activityIndicatorView.stopAnimating()
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

@available(iOS 16.0, *)
private extension AccountViewController{
    @available(iOS 16.0, *)
    func hostingGraphView(){
        let chartView = LineChartView(graphViewModel: viewModel)
        let controller = UIHostingController(rootView: chartView)
        addChild(controller)
        chartBack.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view?.translatesAutoresizingMaskIntoConstraints = false
        controller.view.heightAnchor.constraint(equalToConstant: 0).isActive = true
        controller.view?.leftAnchor.constraint(equalTo: self.chartBack.leftAnchor, constant: 20).isActive = true
        controller.view?.rightAnchor.constraint(equalTo: self.chartBack.rightAnchor, constant: 0).isActive = true
        controller.view.topAnchor.constraint(equalTo: self.aveLabel.bottomAnchor, constant: 80).isActive = true
        controller.view?.centerXAnchor.constraint(equalTo: self.chartBack.centerXAnchor).isActive = true
    }
}
