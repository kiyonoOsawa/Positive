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
    let password: String?
    
    init(userData: [String:Any]){
        self.friendList = userData["friendList"] as? [String]
        self.userName = userData["userName"] as? String
        self.userId = userData["userId"] as? String
        self.password = userData["password"] as? String
    }
}
