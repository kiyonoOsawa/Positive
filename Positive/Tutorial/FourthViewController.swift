//
//  FourthViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/12/11.
//

import UIKit

class FourthViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!

    var tappedButton: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
    }
    
    @IBAction func nextMove(_sender: Any) {
        tappedButton()
    }
    
    private func design() {
        nextButton.layer.cornerRadius = 32
    }
}
