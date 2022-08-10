//
//  ReviewViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/30.
//

import UIKit

class ReviewViewController: UIViewController {
    
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
