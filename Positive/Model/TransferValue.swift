//
//  TransferValue.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/09.
//

import Foundation
import UIKit
class TransferValue{
    static let shared = TransferValue()
    var eachAnswer: [String] = ["","",""]
    func transferValue(nowToDo: String, essentialThing: String, trigger: String){
        eachAnswer[0] = nowToDo
        eachAnswer[1] = essentialThing
        eachAnswer[2] = trigger
    }
}
