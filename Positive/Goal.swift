//
//  Goal.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/03.
//

import Foundation
import FirebaseFirestore

struct DetailGoal {
    let goal: String
    let person: String?
    let trigger: String?
    let nowTodo: String?
//    let easyTodo: String?
    let essentialThing: String?
    let review: String?
//    let importance: Double?
    let date: Timestamp
    let documentID: String
    let userId: String
    let userName: String?
    let createdAt: Timestamp
    let isShared: Bool?
    
    init(dictionary: [String:Any], documentID: String) {
        self.goal = dictionary["goal"] as! String
        self.person = dictionary["person"] as? String
        self.trigger = dictionary["trigger"] as? String
        self.nowTodo = dictionary["nowTodo"] as? String
//        self.easyTodo = dictionary["easyTodo"] as? String
        self.essentialThing = dictionary["essentialThing"] as? String
        self.review = dictionary["review"] as? String
//        self.importance = dictionary["importance"] as? Double
        self.date = dictionary["date"] as! Timestamp
        self.documentID = documentID
        self.userId = dictionary["userId"] as! String
        self.userName = dictionary["userName"] as? String
        self.createdAt = dictionary["createdAt"] as! Timestamp
        self.isShared = dictionary["isShared"] as? Bool
    }
}
