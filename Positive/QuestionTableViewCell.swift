//
//  QuestionTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/19.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popButton: UIButton!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!

    weak var delegate: QuestionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        design()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func design() {
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        answerField.leftView = leftPadding
        answerField.leftViewMode = .always
    }
    
    @IBAction func tappedQuestionCell() {
        delegate?.didExtendButton(cell: self)
    }
}

protocol QuestionTableViewCellDelegate: AnyObject {
    func didExtendButton(cell: QuestionTableViewCell)
}
