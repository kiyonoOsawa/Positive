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
        answerField.layer.cornerRadius = 15
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        answerField.inputView = leftPadding
        answerField.leftViewMode = .always
//        let myCell = UICollectionViewCell
//        let topBorder = CALayer()
//        topBorder.frame = CGRect(x: 0, y: 0, width: myCell.frame.width, height: 1.0)
//        topBorder.backgroundColor = UIColor.lightGray.cgColor
//
//        //作成したViewに上線を追加
//        myCell.layer.addSublayer(topBorder)
        
        //        answerField.topAnchor = .alwa
        //        answerField.padding(.top)
        //        answerField.frame(alignm)
    }
    
    @IBAction func tappedQuestionCell() {
        delegate?.didExtendButton(cell: self)
    }
}

protocol QuestionTableViewCellDelegate: AnyObject {
    func didExtendButton(cell: QuestionTableViewCell)
}
