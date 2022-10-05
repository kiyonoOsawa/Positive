//
//  MyListViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/04.
//

import UIKit

class MyListViewController: UIViewController {
    
    @IBOutlet weak var categoryListTable: UITableView!
    
    var allTargetCell = CategoryTableViewCell()
    var deadTargetCell = CategoryTableViewCell()
    var reviewCell = CategoryTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        categoryListTable.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        categoryListTable.dataSource = self
        categoryListTable.delegate = self
    }
    
    @IBAction func backView() {
        self.dismiss(animated: true)
    }
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            allTargetCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
            allTargetCell.selectionStyle = UITableViewCell.SelectionStyle.none
            allTargetCell.categoryTitle.text = "すべての目標"
            allTargetCell.categoryIcon.image = UIImage(named: "categoryAll")
            return allTargetCell
        } else if indexPath.section == 1 {
            deadTargetCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
            deadTargetCell.selectionStyle = UITableViewCell.SelectionStyle.none
            deadTargetCell.categoryTitle.text = "期限切れ"
            deadTargetCell.categoryIcon.image = UIImage(named: "categoryDead")
            return deadTargetCell
        } else {
            reviewCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
            reviewCell.selectionStyle = UITableViewCell.SelectionStyle.none
            reviewCell.categoryTitle.text = "振り返り一覧"
            reviewCell.categoryIcon.image = UIImage(named: "categoryReview")
            return reviewCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "toAllView", sender: nil)
            print("画面遷移")
        } else if indexPath.section == 1 {
            
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
