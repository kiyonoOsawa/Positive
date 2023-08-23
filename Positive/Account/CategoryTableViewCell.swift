//
//  CategoryTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/05.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
