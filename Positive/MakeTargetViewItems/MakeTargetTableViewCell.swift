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
        targetTextField.placeholder = "Final Goal"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
}
