//
//  Review.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/19.
//

import Foundation
import FirebaseFirestore

struct Review {
    let reviewDocumentId: String
    let targetDocumentId: String
    let targetGoal: String
    let original: String?
    let reframing: String?
    let date: Timestamp
    let score: Double
    
    init(dictionary: [String:Any], reviewDocumentId: String) {
        self.reviewDocumentId = reviewDocumentId
        self.targetDocumentId = dictionary["target"] as! String
        self.targetGoal = dictionary["targetGoal"] as! String
        self.original = dictionary["original"] as? String
        self.reframing = dictionary["reframing"] as? String
        self.date = dictionary["date"] as! Timestamp
        self.score = dictionary["score"] as! Double
    }
}
