//
//  ImportanceTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/03.
//

import UIKit

class ImportanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var levelStepper: UIStepper!
    @IBOutlet weak var shareSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "共有"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
