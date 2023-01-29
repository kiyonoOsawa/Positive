//
//  DataModel.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/06.
//

import Foundation

class DataModel: Decodable, Identifiable{
    let documentSentiment: DocumentSentiment
    let language: String
    let sentences: [Sentences]
}
//全体のスコアを格納する
class DocumentSentiment: Decodable, Identifiable{
    let magnitude: Double
    let score: Double
}

class Sentences: Decodable, Identifiable {
    let text: Text
    let sentiment: Sentiment
}

class Text: Decodable, Identifiable {
    let content: String
    let beginOffset: Double
}

class Sentiment: Decodable, Identifiable {
    let magnitude: Double
    let score: Double
}

//    var negaposi: Int
//    var analyzedText: String

//    init(negaposi: Int, analyzedText: String) {
//        self.negaposi = negaposi
//        self.analyzedText = analyzedText
//    }
//    enum CodingKeys: String,CodingKey {
//        case negaposi = "negaposi"
//        case analyzedText = "analyzed_text"
//    }
//}
