//
//  QuestionTableViewCell.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/19.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!

    weak var delegate: QuestionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextView.delegate = self
        design()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func design() {
        answerTextView.layer.cornerRadius = 15
//        answerTextView.layer.borderWidth = 0.5
//        answerTextView.layer.borderColor = UIColor(named: "grayTextColor")?.cgColor
        answerTextView.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 5, right: 5)
    }
    
//    @IBAction func tappedQuestionCell() {
//        delegate?.didExtendButton(cell: self)
//    }
}

extension QuestionTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.didChangeText(cell: self, text: textView.text)
    }
}

protocol QuestionTableViewCellDelegate: AnyObject {
    func didExtendButton(cell: QuestionTableViewCell)
    func didChangeText(cell: QuestionTableViewCell, text: String)
}
