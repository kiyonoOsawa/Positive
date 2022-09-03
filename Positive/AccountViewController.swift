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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chartBack: UIView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var aveLabel: UILabel!
    @IBOutlet weak var friendsBack: UIView!
    @IBOutlet weak var friendsCollection: UICollectionView!
    
    let storageRef = Storage.storage().reference(forURL: "gs://positive-898d1.appspot.com")
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
        lineChart()
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
                    let review = Review(dictionary: doc.data())
                    self.rawDataGraph.append(Int(review.score ?? 0))
                    let entries = self.rawDataGraph.enumerated().map { ChartDataEntry(x: Double($0.offset),y: Double($0.element))}
                    self.setChartData(entries: entries)
                    self.setAverageData(scores: self.rawDataGraph)
                }
            }
    }
    
    private func setChartData(entries: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: entries)
        self.lineChartView.data = LineChartData(dataSet: dataSet)
    }
    
    private func setAverageData(scores: [Int]) {
        let average = scores.reduce(0, +) / scores.count
        aveLabel.text = String(average)
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
        lineChartView.leftAxis.axisMinimum = 0        // Y座標の値が0始まりになるように設定
        lineChartView.leftAxis.axisMaximum = 100.0
        lineChartView.leftAxis.drawZeroLineEnabled = true
        lineChartView.leftAxis.zeroLineColor = .systemGray
        let limitLine = ChartLimitLine(limit: 72, label: "ポジティブライン")        // グラフに境界線(横)を追加
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
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInCubic)         // アニメーションをつける
    }
    
    func design() {
        imageView.layer.cornerRadius = 36
        editButton.layer.cornerRadius = 10
        chartBack.layer.cornerRadius = 20
        chartBack.layer.shadowColor = UIColor.black.cgColor
        chartBack.layer.shadowOpacity = 0.25
        chartBack.layer.shadowOffset = CGSize(width: 0, height: 0)
        chartBack.layer.masksToBounds = false
        friendsBack.layer.cornerRadius = 20
        friendsBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        friendsCollection.register(UINib(nibName: "FriendAccCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "accCell")
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
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("画像の取り出しに失敗: \(error)")
            }else{
                let image = UIImage(data: data!)
                cell.friendIcon.contentMode = .scaleAspectFill
                cell.friendIcon.clipsToBounds = true
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



