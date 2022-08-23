////
////  FriendsTargetTableViewCell.swift
////  Positive
////
////  Created by 大澤清乃 on 2022/07/31.
////
//
//import UIKit
//
//class FriendsTargetTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var friendsTargetCollection: UICollectionView!
//
//    var viewWidth: CGFloat = 0.0
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        friendsTargetCollection.delegate = self
//        friendsTargetCollection.dataSource = self
//        friendsTargetCollection.register(UINib(nibName: "FriendsInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendsInner")
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        friendsTargetCollection.collectionViewLayout = layout
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//}
//
//extension FriendsTargetTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsInner", for: indexPath) as! FriendsInnerCollectionViewCell
//        cell.layer.cornerRadius = 15
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 0.25
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.layer.masksToBounds = false
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let space: CGFloat = 0
//        let cellWidth: CGFloat = 160
//        let cellHeight: CGFloat = 120
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
//    }
//}
