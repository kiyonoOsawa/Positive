//
//  ShareViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/25.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var shareCollectionView: UICollectionView!
    
    var viewWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        shareCollectionView.dataSource = self
        shareCollectionView.delegate = self
        shareCollectionView.register(UINib(nibName: "ShareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "shareCell")
        viewWidth = view.frame.width
    }
}

extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareCell", for: indexPath) as! ShareCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 56
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
}
