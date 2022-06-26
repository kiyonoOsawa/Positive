//
//  HomeViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var goalListCollectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var targets: [[String:Any]] = []
    var viewWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        goalListCollectionView.delegate = self
        goalListCollectionView.dataSource = self
        goalListCollectionView.register(UINib(nibName: "HomeTargetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeTarget")
        viewWidth = view.frame.width
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
        
    @IBAction func selectAlert(_ sender: Any){
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //textfieldの中身を保存
        let okAction = UIAlertAction(title: "OK", style: .default){ (UIAlertAction) in
        }
        alert.title = "目標"
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
        })
        
        alert.addAction(
            UIAlertAction(
                title: "追加",
                style: .default,
                handler: {(action) -> Void in
                })
        )
        alert.addAction(
            UIAlertAction(
            title: "キャンセル",
            style: .cancel,
            handler: {(action) -> Void in
            })
        )
        self.present(
                alert,
                animated: true,
                completion: {
                    print("アラートが表示された")
                })
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeTarget", for: indexPath) as! HomeTargetCollectionViewCell
        cell.layer.cornerRadius = 10
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
