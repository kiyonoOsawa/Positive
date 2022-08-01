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

    override func awakeFromNib() {
        super.awakeFromNib()
//        let label = UILabel(frame: .zero)
        friendsGoal.lineBreakMode = .byCharWrapping
    }

}
