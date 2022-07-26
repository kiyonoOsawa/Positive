//
//  ShareCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/25.
//

import UIKit

class ShareCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var shareText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func tappedAccount() {
        
    }

}
