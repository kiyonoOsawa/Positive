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
    var isTappedUpDate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back))
        saveCollectionView.register(UINib(nibName: "SaveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "saveCell")
        saveCollectionView.delegate = self
        saveCollectionView.dataSource = self
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
    
    private func fetchData() {
        guard let user = user else {
            return
        }
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener { [self] QuerySnapshot, Error in
                guard let querySnapShot = QuerySnapshot else {
                    print("error: \(Error.debugDescription)")
                    return
                }
                self.addresses.removeAll()
                print("ここでとる: \(querySnapShot.documents)")
                for doc in querySnapShot.documents {
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    let deadlineDate = DateFormat.shared.self.dateFormat(date: detailGoal.date.dateValue())
                    let today = DateFormat.shared.self.dateFormat(date: Date())
                    if deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending{
                        self.addresses.append(detailGoal)
                    }
                }
                if self.isTappedUpDate {
                    self.initialSet()
                } else {
                    let bottomBorder = CALayer()
                    bottomBorder.frame = CGRect(x: 0, y: self.addData.frame.height, width: self.addData.frame.width, height:2.0)
                    bottomBorder.backgroundColor = UIColor.black.cgColor
                    self.addData.layer.addSublayer(bottomBorder)
                    let delete = CALayer()
                    delete.frame = CGRect(x: 0, y: self.updateDate.frame.height, width: self.updateDate.frame.width, height:2.0)
                    delete.backgroundColor = UIColor.white.cgColor
                    self.updateDate.layer.addSublayer(delete)
                    self.addresses.sort{$0.createdAt.dateValue() > $1.createdAt.dateValue()}
                    self.saveCollectionView.reloadData()
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
        cell.dateLabel.text = DateFormat.shared.dateFormat(date: cellDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backView = self.presentingViewController as! UINavigationController
        let preVC = backView.viewControllers[0] as! ReviewViewController
        preVC.saveGoal = addresses[indexPath.row].goal
        preVC.saveId = addresses[indexPath.row].documentID
        preVC.targetData = addresses[indexPath.row]
        preVC.saveGoalLabel.text = addresses[indexPath.row].goal
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 8
        let cellWidth: CGFloat = view.frame.width - space
        let cellHeight: CGFloat = 72
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
}
