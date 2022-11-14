//
//  InnerCollectionViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/08/01.
//

import UIKit

class InnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var miniGoal: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var stepView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iineLabel: UILabel!
    @IBOutlet weak var hartImage: UIImageView!
    
    weak var delegate: HomeViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.tappedDelete(cell: self)
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        delegate?.tappedReview(cell: self)
    }
    @IBAction func doneButton(_ sender: Any) {
        delegate?.tappedDone(cell: self)
    }
    
    private func design() {
        let mainColor = UIColor(named: "MainColor")
        guard let mainColor = mainColor else { return }
        miniGoal.isEditable = false
        miniGoal.isSelectable = false
        stepView.image = UIImage(named: "step_fire")
        reviewButton.layer.cornerRadius = 10
        reviewButton.layer.borderWidth = 3
        reviewButton.layer.borderColor = mainColor.cgColor
        doneButton.layer.cornerRadius = 10
    }
}

protocol HomeViewCellDelegate: AnyObject{
    func tappedDelete(cell: InnerCollectionViewCell)
    func tappedReview(cell: InnerCollectionViewCell)
    func tappedDone(cell: InnerCollectionViewCell)
}
