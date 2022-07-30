//
//  ReviewViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/30.
//

import UIKit

class ReviewViewController: UIViewController {
    
//    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var reviewTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedSave() {
        
    }
    
    func design() {
        reviewTextField.layer.cornerRadius = 15
//        reviewTextField.background
    }
}
