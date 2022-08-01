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
    @IBOutlet weak var backTableView: UITableView!
    //    @IBOutlet weak var goalListCollectionView: UICollectionView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    //    var targets: [[String:Any]] = []
    var viewWidth: CGFloat = 0.0
    var addresses: [DetailGoal] = []
    //    var applicableData: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backTableView.delegate = self
        backTableView.dataSource = self
        //        goalListCollectionView.register(UINib(nibName: "HomeTargetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeTarget")
        //        viewWidth = view.frame.width
        backTableView.register(UINib(nibName: "MyTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "OuterCell")
        backTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "variusCell")
        backTableView.register(UINib(nibName: "FriendsTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "friendsTarget")
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
                    let detailGoal = DetailGoal(dictionary: doc.data())
                    self.addresses.append(detailGoal)
                }
                self.backTableView.reloadData()
            }
    }
    
    func design() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        backTableView.layer.cornerRadius = 20
        backTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let myTarget = tableView.dequeueReusableCell(withIdentifier: "OuterCell") as! MyTargetTableViewCell
            return myTarget
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let reviewCell = tableView.dequeueReusableCell(withIdentifier: "variusCell") as! HomeTableViewCell
                reviewCell.selectionStyle = .none
                reviewCell.titleLabel.text = "Review"
                return reviewCell
            } else if indexPath.row == 1 {
                let levelCell = tableView.dequeueReusableCell(withIdentifier: "variusCell") as! HomeTableViewCell
                levelCell.selectionStyle = .none
                levelCell.titleLabel.text = "Level"
                return levelCell
            } else {
                let finishCell = tableView.dequeueReusableCell(withIdentifier: "variusCell") as! HomeTableViewCell
                finishCell.selectionStyle = .none
                finishCell.titleLabel.text = "Finish Targets"
                return finishCell
            }
        } else {
            let friendTarget = tableView.dequeueReusableCell(withIdentifier: "friendsTarget") as! FriendsTargetTableViewCell
            return friendTarget
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 320
        } else if indexPath.section == 2{
            return 180
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "nextMakeView", sender: nil)
        } else {
            return
        }
    }
}
