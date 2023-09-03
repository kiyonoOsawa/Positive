//
//  TabBarViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/04.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var authStateManager = AuthStateManager.shared
    
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
            authStateManager.promptLogin(viewController: self)
            return false
        }
        return true
    }
}
