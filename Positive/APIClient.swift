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
    fileprivate let apiKey = "B2D31DB6A39BE1DB48F26CBC3E409E4CC9E45955"
    let format = "json"
    func getDegreeofSentiment(encodedWord: String, completion: @escaping(Result < DataModel, Error>)->Void) {
        let strToUTF8 = encodedWord.utf8
        let url: String = "http://ap.mextractr.net/ma9/negaposi_analyzer?out=\(format)&apikey=\(apiKey)&text=\(strToUTF8)"
        let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(encodeURL)
            .responseDecodable(of: DataModel.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        return
                    }
                    do {
                        let sentiments = try JSONDecoder().decode(DataModel.self, from: data)
                        completion(.success(sentiments))
                    } catch {
                        completion(.failure(error))
                        print("decode error")
                    }
                case .failure:
                    print("error: \(response.result)")
                }
            }
    }
}
