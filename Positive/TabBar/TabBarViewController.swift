//
//  TabBarViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/04.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.init(name: "HelveticaNeue-Bold", size: 13), .foregroundColor: UIColor(named: "MainColor")], for: .selected)
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.4
        tabBar.layer.cornerRadius = 25
        tabBar.layer.masksToBounds = false
        tabBar.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let user = Auth.auth().currentUser
        if user == nil && viewController == tabBarController.viewControllers?[2] {
            let storyboard : UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "firstAccView")
            self.present(nextVC, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        if user == nil {
    //            AlertDialog.shared.showAlert(title: "ユーザーが存在していません", message: "ログインしてください", viewController: self){
    //                let storyboard: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
    //                let nextVC = storyboard.instantiateViewController(withIdentifier: "firstAccView")
    //                nextVC.modalPresentationStyle = .fullScreen
    //                self.present(nextVC, animated: true, completion: nil)
    //            }
    //        }
    //    }
}
