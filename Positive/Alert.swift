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
    func showAlert(title: String, message: String, viewController: UIViewController, completion: @escaping() -> Void) {
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
        //        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
}
