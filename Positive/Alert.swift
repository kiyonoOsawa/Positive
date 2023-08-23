//
//  Alert.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/20.
//

import Foundation
import UIKit

struct AlertDialog {
    static let shared = AlertDialog()
    func showSaveAlert(title: String, message: String, viewController: UIViewController, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            completion()
        }
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showReviewAlert(title: String, message: String, viewController: UIViewController, completionSave: @escaping() -> Void, completionReframing: @escaping() -> Void) {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let save = UIAlertAction(title: "そのまま保存", style: .default) { (action) in
                completionSave()
            }
            let judge = UIAlertAction(title: "リフレーミングする", style: .default) { (action) in
                completionReframing()
            }
            
            let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                        (action: UIAlertAction!) -> Void in
                        print("Cancel")
                    })
            alert.addAction(save)
            alert.addAction(judge)
            alert.addAction(cancel)
            viewController.present(alert, animated: true, completion: nil)
        }
    
    func showSingleAlert(title: String, message: String,viewController: UIViewController,completion: @escaping()->Void){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                completion()
            }
            alert.addAction(ok)
            viewController.present(alert, animated: true, completion: nil)
        }
}
