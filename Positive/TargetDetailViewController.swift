//
//  TargetDetailViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/26.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TargetDetailViewController: UIViewController {
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var miniTargetTextView: UITextView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var addresses: [DetailGoal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        guard let user = user else {
            return
        }
        self.addresses.removeAll()
        db.collection("users")
            .document(user.uid)
            .collection("goals")
            .addSnapshotListener{ QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {
                    return
                }
                for doc in querySnapshot.documents {
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    self.addresses.append(detailGoal)
                }
                self.targetLabel.reloadInputViews()
                self.miniTargetTextView.reloadInputViews()
            }
    }
    
    func displayData() {
//        targetLabel.text = addresses.
    }
}
