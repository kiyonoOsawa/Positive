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
        alert.addAction(ok)
        viewController.present(alert, animated: true, completion: nil)
    }
}
