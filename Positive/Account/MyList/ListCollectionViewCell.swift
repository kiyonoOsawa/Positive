//
//  ListCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/05.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var deadLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    weak var delegate: ListCollectionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.tappedDelete(cell: self)
    }
}

protocol ListCollectionDelegate: AnyObject {
    func tappedDelete(cell: ListCollectionViewCell)
}
