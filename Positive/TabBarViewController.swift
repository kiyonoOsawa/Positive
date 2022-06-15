//
//  TabBarViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/04.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let mainColor = UIColor(named: "MainColor")
//        guard let mainColor = mainColor else { return }
        UITabBar.appearance().tintColor = UIColor(named: "MainColor")
    }
}
