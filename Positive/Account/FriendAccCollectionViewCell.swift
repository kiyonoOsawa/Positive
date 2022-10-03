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
    @IBOutlet weak var deleteButton: UIButton!
    
//    weak var delegate:FriendAccountDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
//    @IBAction func deleteButton(_ sender: Any) {
//        delegate?.tappedDelete(cell: self)
//    }
    
    func design() {
        friendIcon.layer.cornerRadius = 36
    }
}

//protocol FriendAccountDelegate: AnyObject{
//    func tappedDelete(cell: FriendAccCollectionViewCell)
//}
