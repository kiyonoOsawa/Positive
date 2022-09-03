//
//  FriendsInnerCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/01.
//

import UIKit

class FriendsInnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var accNameLabel: UILabel!
    @IBOutlet weak var friendsGoal: UILabel!
//    @IBOutlet weak var nilImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        friendsGoal.lineBreakMode = .byCharWrapping
        design()
    }

    func design() {
        iconImage.layer.cornerRadius = 21
        iconImage.layer.borderColor = UIColor(named: "grayTextColor")?.cgColor
        iconImage.layer.borderWidth = 2
    }
}
