//
//  APIClient.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/03.
//

import Foundation
import Alamofire
struct APIClient {
    static let shared = APIClient()
    fileprivate let apiKey = "5C4A43812C0FBB5E2FA9F5D63DE2D8C864A96638"
    let format = "json"
    func getDegreeofSentiment(encodedWord: String, completion: @escaping(Result<[DataModal], Error>)->Void) {
        
    }
}
