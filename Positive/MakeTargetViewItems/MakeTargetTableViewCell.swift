//
//  MakeTargetTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/03.
//

import UIKit

class MakeTargetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var targetTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
//        targetTextField.placeholder = "最終目標"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteText(_ sender: UIButton) {
     targetTextField.text = ""
    }
}
