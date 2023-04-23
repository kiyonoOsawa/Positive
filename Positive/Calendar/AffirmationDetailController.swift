//
//  AffirmationDetailController.swift
//  Positive
//
//  Created by 大澤清乃 on 2023/04/23.
//

import UIKit
import Firebase
import FirebaseStorage

class AffirmationDetailController: UIViewController {
    
    @IBOutlet weak var affirmationText: UITextView!
    @IBOutlet weak var affirmationScoreLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
    var target = String()
    var review = String()
    var affirmationScore: Double = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
    }
    
    private func design() {
        affirmationText.isEditable = false
        affirmationText.isSelectable = false
        affirmationText.text = review
        let positiveness: Double = Double(affirmationScore)
        affirmationScoreLabel.text = "\(positiveness)"
        targetLabel.text = target
    }
    
    private func fetchReviewData() {
//        let user =
    }
    
}
