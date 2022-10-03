//
//  CalendarTargetCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/28.
//

import UIKit

class CalendarTargetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bigTargetLabel: UILabel!
    @IBOutlet weak var miniTargetLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: CalendarViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.tappedDelete(cell: self)
    }
}

protocol CalendarViewDelegate: AnyObject{
    func tappedDelete(cell: CalendarTargetCollectionViewCell)
}
