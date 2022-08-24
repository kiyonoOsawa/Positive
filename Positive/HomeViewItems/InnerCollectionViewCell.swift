//
//  InnerCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/01.
//

import UIKit

class InnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var miniGoal1: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var stepView: UIImageView!
    @IBOutlet weak var buttonBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    @IBAction func tappedDone() {
        
    }
    
//    @IBAction func tappedReview() {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "reviewVC") as! ReviewViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    func performSegueToResults() {
//        performSegue(widthIden)
//    }
    
    func design() {
//        let topBorder = CALayer()
//        topBorder.frame = CGRect(x: 0, y: 0, width: buttonBack.frame.width, height: 1.0)
//        topBorder.backgroundColor = UIColor.lightGray.cgColor
//        buttonBack.layer.addSublayer(topBorder)
//        let rightBorder = CALayer()
//        rightBorder.frame = CGRect(x: doneButton.frame.width, y: 0, width: 1.0, height:doneButton.frame.height)
//        rightBorder.backgroundColor = UIColor.lightGray.cgColor
//        doneButton.layer.addSublayer(rightBorder)
        buttonBack.layer.cornerRadius = 25
        buttonBack.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
