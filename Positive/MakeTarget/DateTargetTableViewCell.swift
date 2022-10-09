//
//  DateTargetTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/03.
//

import UIKit

class DateTargetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: DateTargetTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapChangeVisibleButton() {
        delegate?.didTapChangeVisibleButton(cell: self)
    }
}

protocol DateTargetTableViewCellDelegate: AnyObject {
    func didTapChangeVisibleButton(cell: DateTargetTableViewCell)
}
