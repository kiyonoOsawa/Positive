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
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    @IBOutlet weak var targetCollection: UICollectionView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var friendTargetCollection: UICollectionView!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var nilTargetImage: UIImageView!
    @IBOutlet weak var nilFriendSTarget: UIImageView!
    @IBOutlet weak var friendLabel: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var viewWidth: CGFloat = 366
    var addresses: [DetailGoal] = []
    var friends: User? = nil
    var addressesFriends: [DetailGoal] = []
    var userName: String = ""
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("friendsBackの横幅")
        print(friendsBack.frame.width)
        targetCollection.delegate = self
        targetCollection.dataSource = self
        friendTargetCollection.delegate = self
        friendTargetCollection.dataSource = self
        targetCollection.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "targetHome")
        friendTargetCollection.register(UINib(nibName: "FriendsInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendsTarget")
        targetCollection.decelerationRate = .fast
        let layout = FlowLayout()
        layout.scrollDirection = .horizontal // 横スクロール
        targetCollection.collectionViewLayout = layout
        targetCollection.showsHorizontalScrollIndicator = false
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "shadowImage")
        design()
        fetchData()
        fetchFriendsData()
    }
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
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
                    let deadlineDate = self.dateFormat(date: detailGoal.date.dateValue())
                    let today = self.dateFormat(date: Date())
                    if deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending{
                        self.addresses.append(detailGoal)
                    }
                }
                self.targetCollection.reloadData()
                print("目標が表示される")
                self.friendTargetCollection.reloadData()
            }
    }
    
    private func fetchFriendsData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { return }
                guard let data = document.data() else { return }
                self.friends = User(userData: data)
                self.userName = data["userName"] as! String
                guard let user = self.friends else { return }
                guard let friendList = user.friendList else { return }
                self.db.collectionGroup("goals")
                    .whereField("userId", in: friendList)
                    .addSnapshotListener { QuerySnapshot, Error in
                        guard let querySnapshot = QuerySnapshot else {
                            print("error: \(Error.debugDescription)")
                            return
                        }
                        self.addressesFriends.removeAll()
                        for doc in querySnapshot.documents {
                            let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                            if detailGoal.isShared ?? true{
                                self.addressesFriends.append(detailGoal)
                            }
                            print("addressesFriends:\(self.addressesFriends)")
                        }
                        self.friendTargetCollection.reloadData()
                        
                    }
            }
    }
    
    func design() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        targetCollection.layer.cornerRadius = 25
        targetCollection.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        targetCollection.backgroundColor = .clear
        friendsBack.layer.cornerRadius = 25
        friendsBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        friendTargetCollection.backgroundColor = .clear
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if addresses.count == 0 {
                nilTargetImage.image = UIImage(named: "myTarget")
                myLabel.isHidden = true
            } else {
                nilTargetImage.image = nil
                myLabel.isHidden = false
            }
            return addresses.count
        } else {
            if addressesFriends.count == 0 {
                nilFriendSTarget.image = UIImage(named: "friendsTarget")
                friendLabel.isHidden = true
            } else {
                nilFriendSTarget.image = nil
                friendLabel.isHidden = false
            }
            return addressesFriends.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "targetHome", for: indexPath) as! InnerCollectionViewCell
            cell.layer.cornerRadius = 25
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5
            cell.layer.masksToBounds = false
            let cellDate = addresses[indexPath.row].date.dateValue()
            cell.dateLabel.text = dateFormat(date: cellDate)
            cell.goalLabel.text = addresses[indexPath.row].goal
            cell.miniGoal.text = addresses[indexPath.row].nowTodo
            let iineList = addresses[indexPath.row].iineUsers
            //            var string = ""
            //            iineList.forEach { user in
            //                string += user
            //            }
            if !iineList.isEmpty{
                cell.iineLabel.text = "\(iineList.count)"
            } else {
                cell.iineLabel.text = "0"
            }
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsTarget", for: indexPath) as! FriendsInnerCollectionViewCell
            let friendId = addressesFriends[indexPath.row].userId
            cell.delegate = self
            cell.friendsGoal.text = addressesFriends[indexPath.row].goal
            cell.accNameLabel.text = addressesFriends[indexPath.row].userName
            let imagesRef = self.storageRef.child("userProfile").child("\(friendId).jpg")
            imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("画像の取り出しに失敗: \(error)")
                } else {
                    
                    let image = UIImage(data: data!)
                    cell.iconImage.contentMode = .scaleAspectFill
                    cell.iconImage.clipsToBounds = true
                    cell.iconImage.image = image
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let cellWidth: CGFloat = self.view.frame.width - 76
            let cellHeight: CGFloat = targetCollection.frame.height - 70
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let space: CGFloat = 10
            let cellWidth: CGFloat = friendTargetCollection.frame.width - space
            let cellHeight: CGFloat = 88
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 23, left:38, bottom: 0, right: 38)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let nextNC = storyboard?.instantiateViewController(withIdentifier: "detailTarget") as! TargetDetailViewController
            nextNC.modalTransitionStyle = .coverVertical
            nextNC.modalPresentationStyle = .pageSheet
            nextNC.Goal = addresses[indexPath.row].goal
            nextNC.MiniGoal = addresses[indexPath.row].nowTodo!
            nextNC.Trigger = addresses[indexPath.row].trigger!
            nextNC.EssentialThing = addresses[indexPath.row].essentialThing!
            nextNC.DocumentId = addresses[indexPath.row].documentID
            nextNC.IsShared = addresses[indexPath.row].isShared ?? true
            navigationController?.pushViewController(nextNC, animated: true)
        } else {
            return
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        (targetCollection.collectionViewLayout as! FlowLayout).prepareForPaging()
    }
}

extension HomeViewController: FriendsCellDelegate{
    func tappedIine(cell: FriendsInnerCollectionViewCell) {
        if let indexPath = friendTargetCollection.indexPath(for: cell){
            let userId = addressesFriends[indexPath.row].userId
            let documentId = addressesFriends[indexPath.row].documentID
            
            var iineList: [String] = []
            iineList.append(userName)
            self.db.collection("users")
                .document(userId)
                .collection("goals")
                .document(documentId)
                .updateData(["iineUsers": FieldValue.arrayUnion(iineList)])
            var image = UIImage(systemName: "heart.fill")
            let state = UIControl.State.normal
            cell.iineButton.setImage(image, for: state)
        }
    }
}

extension HomeViewController: HomeViewCellDelegate {
    func tappedDelete(cell: InnerCollectionViewCell) {
        AlertDialog.shared.showAlert(title: "目標を削除しますか？", message: "", viewController: self) {
            delete()
        }
        
        func delete() {
            guard let user = user else {return}
            if let indexPath = targetCollection.indexPath(for: cell){
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
                targetCollection.reloadData()
                friendTargetCollection.reloadData()
            }
        }
    }
    
    func tappedReview(cell: InnerCollectionViewCell) {
        if let indexPath = targetCollection.indexPath(for: cell) {
            let storyboard: UIStoryboard = self.storyboard!
            let nc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            nc.modalPresentationStyle = .fullScreen
            let nextNC = nc.viewControllers[0] as! ReviewViewController
            nextNC.targetData = addresses[indexPath.row]
            self.present(nc, animated: true, completion: nil)
        }
    }
}
