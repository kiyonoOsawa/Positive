//
//  FriendAccCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/25.
//

import UIKit

class FriendAccCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendIcon: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    func design() {
        friendIcon.layer.cornerRadius = 36
    }
}
