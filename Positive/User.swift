//
//  User.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/29.
//

import Foundation

struct User{
    let friendList: [String]?
    let userName: String?
    let userId: String?
    let userEmail: String?
    
    init(userData: [String:Any]){
        self.friendList = userData["friendList"] as? [String]
        self.userName = userData["name"] as? String
        self.userId = userData["userId"] as? String
        self.userEmail = userData["email"] as? String
    }
}
