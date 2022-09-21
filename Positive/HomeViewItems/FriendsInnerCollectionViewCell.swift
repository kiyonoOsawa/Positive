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
    @IBOutlet weak var iineButton: UIButton!
    
    weak var delegate: FriendsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        friendsGoal.lineBreakMode = .byCharWrapping
        design()
    }
    
    @IBAction func tappedIineButton(_ sender: Any) {
        delegate?.tappedIine(cell: self)
    }
    
    func design() {
        iconImage.layer.cornerRadius = 21
        friendsGoal.lineBreakMode = .byCharWrapping
    }
}

protocol FriendsCellDelegate: AnyObject{
    func tappedIine(cell: FriendsInnerCollectionViewCell)
}
