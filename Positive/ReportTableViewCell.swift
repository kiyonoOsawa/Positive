//
//  ReportTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var targetText: UITextField!
    
    weak var delegate: CellExtendDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        targetText.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func tapPopButton() {
        delegate?.didExtendButton(cell: self)
        print("ボタンを押した")
    }
}
protocol CellExtendDelegate: AnyObject {
    func didExtendButton(cell: ReportTableViewCell)
}
