//
//  TabBarViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/04.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.init(name: "HelveticaNeue-Bold", size: 13), .foregroundColor: UIColor(named: "MainColor")], for: .selected)
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.4
        tabBar.layer.cornerRadius = 25
        tabBar.layer.masksToBounds = false
        tabBar.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let userDefaults = UserDefaults.standard
//        let firstLunchKey = "firstLunchKey"
//        if userDefaults.bool(forKey: firstLunchKey) {
//            userDefaults.set(false, forKey: firstLunchKey)
//            let nextVC = storyboard?.instantiateViewController(withIdentifier: "firstAccView")
//            nextVC?.modalPresentationStyle = .fullScreen
//            self.present(nextVC!, animated: true, completion: nil)
//        }
        if user == nil{
            let storyboard: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "firstAccView")
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }
}
