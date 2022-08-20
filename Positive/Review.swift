//
//  Review.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/19.
//

import Foundation
import FirebaseFirestore

struct Review {
    let targetDocumentId: String
    let original: String?
    let reframing: String?
    let date: Timestamp
    
    init(dictionary: [String:Any]){
        self.targetDocumentId = dictionary["target"] as! String
        self.original = dictionary["original"] as? String
        self.reframing = dictionary["reframing"] as? String
        self.date = dictionary["date"] as! Timestamp
    }
}
