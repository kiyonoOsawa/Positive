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
    fileprivate let apiKey = "AIzaSyB09q-_nkpDJAP4fGa7-XDo3k6xURb0qNk"
    //    let format = "json"
    func getDegreeofSentiment(encodedWord: String, completion: @escaping(Result < DataModel, Error>)->Void) {
        let jsonRequest: Parameters =
        ["document":[
            "type":"PLAIN_TEXT",
            "language": "ja",
            "content":"\(encodedWord)"
        ],
         "encodingType":"UTF8"
        ]
        let url: String = "https://language.googleapis.com/v1/documents:analyzeSentiment?key=\(apiKey)"
        //②
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": "\(Bundle.main.bundleIdentifier ?? "")",
            "Content-Type": "application/json"
        ]
        AF.request(url, method: .post ,parameters: jsonRequest, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: DataModel.self) { response in
            switch response.result{
            case .success(_):
                guard let data = response.data else {
                    return
                }
                do {
                    let sentiments = try JSONDecoder().decode(DataModel.self, from: data)
                    completion(.success(sentiments))
                } catch {
                    completion(.failure(error))
                    print("decode error: \(error)")
                }
            case .failure(_):
                print("error: \(response.result)")
            }
        }
    }
}
