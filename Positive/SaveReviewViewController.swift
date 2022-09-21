//
//  SaveReviewViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/09/20.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SaveReviewViewController: UIViewController {
    
    @IBOutlet weak var updateDate: UIButton!
    @IBOutlet weak var addData: UIButton!
    @IBOutlet weak var saveCollectionView: UICollectionView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var addresses: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back))
        saveCollectionView.register(UINib(nibName: "SaveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "saveCell")
        saveCollectionView.delegate = self
        saveCollectionView.dataSource = self
        //        pickerView.delegate = self
        //        pickerView.dataSource = self
        fetchData()
        initialSet()
        design()
    }
    
    @IBAction func tappedUpDateDate() {
        initialSet()
    }
    
    @IBAction func tappedAddDate() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: addData.frame.height, width: addData.frame.width, height:2.0)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        addData.layer.addSublayer(bottomBorder)
        let delete = CALayer()
        delete.frame = CGRect(x: 0, y: updateDate.frame.height, width: updateDate.frame.width, height:2.0)
        delete.backgroundColor = UIColor.white.cgColor
        updateDate.layer.addSublayer(delete)
        addresses.sort{$0.date.dateValue() > $1.date.dateValue()}
        saveCollectionView.reloadData()
    }
    
    @objc private func back() {
        dismiss(animated: true)
    }
    
    func initialSet() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: updateDate.frame.height, width: updateDate.frame.width, height:2.0)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        updateDate.layer.addSublayer(bottomBorder)
        let delete = CALayer()
        delete.frame = CGRect(x: 0, y: addData.frame.height, width: addData.frame.width, height:2.0)
        delete.backgroundColor = UIColor.white.cgColor
        addData.layer.addSublayer(delete)
        addresses.sort{$0.createdAt.dateValue() > $1.createdAt.dateValue()}
        saveCollectionView.reloadData()
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
//                    let createDate = self.dateFormat(date: detailGoal.createdAt.dateValue())
                    let today = self.dateFormat(date: Date())
                    if deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending{
                        self.addresses.append(detailGoal)
                    }
                }
                self.saveCollectionView.reloadData()
                print("目標が表示される")
            }
    }
    
    func design() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "rightTextColor")
    }
}

extension SaveReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveCell", for: indexPath) as! SaveCollectionViewCell
        cell.saveLabel.text = addresses[indexPath.row].goal
        let cellDate = addresses[indexPath.row].date.dateValue()
        cell.dateLabel.text = dateFormat(date: cellDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let preNC = self.navigationController!
//        let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! ReviewViewController
        let preVC = self.presentingViewController as! ReviewViewController
        preVC.saveGoal = addresses[indexPath.row].goal
        preVC.saveId = addresses[indexPath.row].documentID
        print("値渡し\(preVC.saveGoal)")
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 10
        let cellWidth: CGFloat = saveCollectionView.frame.width - space
        let cellHeight: CGFloat = 48
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//extension SaveReviewViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let searchText = searchBar.text else {
//            return
//        }
//        print(searchText)  //SeachBarに入力された文字列が出力されるはず
//    }
//
//    private func search(_ text: String) {
//        var filterdArr: [String:Any] = [:]
//        if let text = searchBar.text {
//            if text == "" {
//                saveCollectionView.reloadData()
//            } else {
//                filterdArr = addresses.filter { (str) -> Bool in
//                    return str.contains(text)
//                }
//                saveCollectionView.reloadData()
//            }
//        }
//    }
//}
