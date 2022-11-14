//
//  FirebaseClient.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/11/13.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseClient {
    @Published var target: [DetailGoal] = []
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var addresses: [DetailGoal] = []
    
    func fetchData() {
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
//                self.addresses.removeAll()
                print("ここでとる: \(querySnapShot.documents)")
                for doc in querySnapShot.documents {
                    let detailGoal = DetailGoal(dictionary: doc.data(), documentID: doc.documentID)
                    let deadlineDate = DateFormat.shared.self.dateFormat(date: detailGoal.date.dateValue())
                    let today = DateFormat.shared.self.dateFormat(date: Date())
                    if deadlineDate.compare(today) == .orderedSame || deadlineDate.compare(today) == .orderedDescending{
                        self.target.append(detailGoal)
                    }
                }
            }
    }
}
