//
//  ReviewViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/30.
//

import UIKit
import Foundation
import Alamofire
//struct APIClient {
//    static let shared = APIClient()
//    //apiのキー
//    fileprivate let apiKey = "5C4A43812C0FBB5E2FA9F5D63DE2D8C864A96638"
//    let format = "json"
//    func getDegreeofSentiment(encodedWord: String, completion: @escaping(Result<[DataModel], Error>)->Void) {
//        let strToUTF8 = encodedWord.utf8
//        let url: String = "http://ap.mextractr.net/ma9/negaposi_analyzer?out=\(format)&apikey=\(apiKey)&text=\(strToUTF8)"
//        let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        AF.request(encodeURL)
//            .responseDecodable
//    }
//}

class ReviewViewController: UIViewController {
    
//    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var targetPickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        design()
    }
    
    @IBAction func tappedSave() {
        
    }
    
    func design() {
        reviewTextField.layer.cornerRadius = 15
        reviewTextField.placeholder = "Review..."
//        reviewTextField.backgroundColor = UIColor.black
    }
}
