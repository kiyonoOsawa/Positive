//
//  HomeViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var alertButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectAlert(_ sender: Any){
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "目標"
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
        })
        
        alert.addAction(
            UIAlertAction(
                title: "追加",
                style: .default,
                handler: {(action) -> Void in
//                    self.hello(action.title!)
                })
        )
        alert.addAction(
            UIAlertAction(
            title: "キャンセル",
            style: .cancel,
            handler: {(action) -> Void in
            })
        )
        self.present(
                alert,
                animated: true,
                completion: {
                    print("アラートが表示された")
                })
    }

}
