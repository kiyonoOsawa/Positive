//
//  InnerCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/01.
//

import UIKit

class InnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var miniGoal1: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var stepView: UIImageView!
//    @IBOutlet weak var buttonBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    func design() {
        let mainColor = UIColor(named: "MainColor")
        guard let mainColor = mainColor else { return }
//        buttonBack.layer.cornerRadius = 25
//        buttonBack.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        doneButton.layer.cornerRadius = 15
        reviewButton.layer.cornerRadius = 15
        reviewButton.layer.borderWidth = 3
        reviewButton.layer.borderColor = mainColor.cgColor
    }
}
