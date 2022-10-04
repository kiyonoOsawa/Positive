//
//  CategoryCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/04.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leftBar: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 15
        leftBar.layer.cornerRadius = 15
        leftBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

}
