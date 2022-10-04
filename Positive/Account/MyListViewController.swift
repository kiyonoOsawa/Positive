//
//  MyListViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/04.
//

import UIKit

class MyListViewController: UIViewController {
    
    @IBOutlet weak var categoryListCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryListCollection.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        categoryListCollection.delegate = self
        categoryListCollection.dataSource = self
    }
}

extension MyListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false
//        cell.leftBar.layer.cornerRadius = 10
//        cell.leftBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        if indexPath.section == 0 {
            cell.categoryLabel.text = "すべての目標"
            return cell
        } else if indexPath.section == 1 {
            cell.categoryLabel.text = "締切日を過ぎた目標"
            return cell
        } else if indexPath.section == 2 {
            cell.categoryLabel.text = "振り返り"
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 24
        let cellWidth: CGFloat = categoryListCollection.frame.width - space
        let cellHeight: CGFloat = 72
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
    
}
