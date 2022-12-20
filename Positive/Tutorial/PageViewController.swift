//
//  PageViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/11/28.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var controllers: [UIViewController] = []
    var displayedPage: Int = 0
    var pageNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setController()
    }
    
    private func setController() {
        let firstController = storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        let secondController = storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        let thirdController = storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
        let fourthController = storyboard!.instantiateViewController(withIdentifier: "FourthViewController") as! FourthViewController
        controllers = [firstController, secondController, thirdController, fourthController]
        self.setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
        firstController.tappedButton = {
            self.displayedPage = 0
            self.setViewControllers([self.controllers[1]], direction: .forward, animated: true, completion: nil)
        }
        secondController.tappedButton = {
            self.displayedPage = 1
            self.setViewControllers([self.controllers[2]], direction: .forward, animated: true, completion: nil)
        }
        thirdController.tappedButton = {
            self.displayedPage = 2
            self.setViewControllers([self.controllers[3]], direction: .forward, animated: true, completion: nil)
        }
        fourthController.tappedButton = {
            self.displayedPage = 3
            self.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    //MARK: 現在の前のページ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(of: viewController)
        if index == 0{
            return nil
        }else{
            return controllers[index!-1]
        }
    }
    //MARK: 現在の後ろのページ指定
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(of: viewController)
        if index == controllers.count - 1 {
            return nil
        }else{
            return controllers[index!+1]
        }
    }
    //MARK: ページ数を返すメソッド
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pageNumber
    }
}
