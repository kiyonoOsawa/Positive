//
//  ImportanceTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/03.
//

import UIKit

class ImportanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareSwitch: UISwitch!
    
    weak var delegate: ImportanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "共有"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            delegate?.onSwitch(cell: self)
        } else {
            delegate?.offSwitch(cell: self)
        }
    }
}

protocol ImportanceCellDelegate: AnyObject{
    func onSwitch(cell: ImportanceTableViewCell)
    func offSwitch(cell: ImportanceTableViewCell)
}

