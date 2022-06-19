//
//  GoalViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/06/05.
//

import UIKit

class GoalViewController: UIViewController {
    
    @IBOutlet weak var goalText: UITextField!
//    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CalendarViewController
        let goal = goalText.text!
        vc.goal = goal
    }
    
    @IBAction func tappedSave(_ sender: Any) {
        self.performSegue(withIdentifier: "toTarget", sender: nil)
        print("ボタン押した")
    }
    

}
