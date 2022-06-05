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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.items![0].image = UIImage(named: "home_icon1x")
        tabBar.items![1].image = UIImage(named: "calendar_icon1x")
        tabBar.items![2].image = UIImage(named: "list_icon1x")
        tabBar.items![0].selectedImage = UIImage(named: "homed_icon1x")
        tabBar.items![1].selectedImage = UIImage(named: "calendared_icon1x")
        tabBar.items![2].selectedImage = UIImage(named: "listed_icon1x")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
