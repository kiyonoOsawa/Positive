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
    @IBOutlet weak var miniGoal2: UILabel!
    @IBOutlet weak var miniGoal3: UILabel!
    @IBOutlet weak var stepView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
