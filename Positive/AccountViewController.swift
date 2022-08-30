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
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chartBack1: UIView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var aveLabel: UILabel!
    @IBOutlet weak var chartBack2: UIView!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var friendsCollection: UICollectionView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var addresses: [DetailGoal] = []
    var friends: User? = nil
    var addressesFriends: [DetailGoal] = []
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
        fetchFriendsData()
        lineChart()
        design()
    }
    
    private func fetchData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
//            .collection("goals")
            .addSnapshotListener { QuerySnapshot, Error in
                guard let querySnapShot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                guard let data = querySnapShot.data() else { return }
                let userName = data["name"] as! String
                self.nameLabel.text = userName
//                self.addresses.removeAll()
//                print("ここでとる: \(querySnapShot.documents)")
//                for doc in querySnapShot.documents {
//                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
//                    self.addresses.append(detailGoal)
//                }
//                self.nameLabel.text = data["name"] as! String
            }
    }
    
    private func fetchFriendsData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .addSnapshotListener { documentSnapshot, Error in
                guard let document = documentSnapshot else { return }
                guard let data = document.data() else { return }
                self.friends = User(userData: data)
                guard let user = self.friends else { return }
                guard let friendList = user.friendList else { return }
                self.db.collectionGroup("goals")
                    .whereField("userId", in: friendList)
                    .addSnapshotListener { QuerySnapshot, Error in
                        guard let querySnapShot = QuerySnapshot else {
                            print("error: \(Error.debugDescription)")
                            return
                        }
                        self.addressesFriends.removeAll()
                        for doc in querySnapShot.documents {
                            let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                            self.addressesFriends.append(detailGoal)
                            print("addressesFriends:\(self.addressesFriends)")
                        }
                        self.friendsCollection.reloadData()
                    }
            }
    }
    
    func lineChart() {
        // Chart dataSet準備
        let entries = rawDataGraph.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.lineWidth = 5        // 線の太さ
        dataSet.drawValuesEnabled = false        // 各プロットのラベル表示
        dataSet.drawCirclesEnabled = true        // 各プロットの丸表示
        dataSet.circleRadius = 2        // 各プロットの丸の大きさ
        dataSet.circleColors = [UIColor.lightGray]        // 各プロットの丸の色
        lineChartView.data = LineChartData(dataSet: dataSet)        // 作成したデータセットをLineChartViewに追加
        lineChartView.xAxis.labelPosition = .bottom        // X軸のラベルの位置を下に設定
        lineChartView.xAxis.labelTextColor = .systemGray        // X軸のラベルの色を設定
        lineChartView.xAxis.drawGridLinesEnabled = false        // X軸の線、グリッドを非表示にする
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.enabled = false        // 右側のY座標軸は非表示にする
        lineChartView.leftAxis.axisMinimum = 0.0         // Y座標の値が0始まりになるように設定
        lineChartView.leftAxis.axisMaximum = 10000.0
        lineChartView.leftAxis.drawZeroLineEnabled = true
        lineChartView.leftAxis.zeroLineColor = .systemGray
        let limitLine = ChartLimitLine(limit: 7200, label: "ポジティブライン")        // グラフに境界線(横)を追加
        limitLine.lineColor = .darkGray
        limitLine.valueTextColor = .darkGray
        lineChartView.leftAxis.addLimitLine(limitLine)
        lineChartView.leftAxis.labelCount = 5        // ラベルの数を設定
        lineChartView.leftAxis.labelTextColor = .systemGray        // ラベルの色を設定
        lineChartView.leftAxis.gridColor = .systemGray        // グリッドの色を設定
        lineChartView.leftAxis.drawAxisLineEnabled = false        // 軸線は非表示にする
        lineChartView.legend.enabled = false        // 凡例を非表示
        lineChartView.highlightPerTapEnabled = false        // タップでプロットを選択できないようにする
        lineChartView.pinchZoomEnabled = false         // ピンチズームオフ
        lineChartView.doubleTapToZoomEnabled = false         // ダブルタップズームオフ
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.3, easingOption: .easeInCubic)         // アニメーションをつける
    }
    
    func design() {
        editButton.layer.cornerRadius = 10
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
//        nameLabel.text = addresses[indexPath.row].
//        nameLabel.text = addresses.
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressesFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accCell", for: indexPath) as! FriendAccCollectionViewCell
        cell.friendIcon.layer.cornerRadius = 36
        let friendId = addressesFriends[indexPath.row].userId
        cell.friendName.text = addressesFriends[indexPath.row].userName
        let imagesRef = self.storageRef.child("userProfile").child("\(friendId).jpg")
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("画像の取り出しに失敗: \(error)")
            }else{
                let image = UIImage(data: data!)
                cell.friendIcon.image = image
            }
        }
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



