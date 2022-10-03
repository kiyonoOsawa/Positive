//
//  DataModel.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/06.
//

import Foundation
class DataModel: Codable,Identifiable{
    var negaposi: Int
    var analyzedText: String
    
    init(negaposi: Int, analyzedText: String) {
        self.negaposi = negaposi
        self.analyzedText = analyzedText
    }
    enum CodingKeys: String,CodingKey {
        case negaposi = "negaposi"
        case analyzedText = "analyzed_text"
    }
}
