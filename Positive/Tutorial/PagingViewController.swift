//
//  PagingViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2023/01/05.
//

import UIKit
import FirebaseAuth

class PagingViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var button: UIButton!
    var viewWidth: CGFloat!
    var viewHeigh: CGFloat!
    var backgroundImageArray: [String] = []
    var fromSignUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        viewWidth = self.view.frame.width
        viewHeigh = self.view.frame.height
        setImageSize()
        setScrollView()
        setImage()
        setPageControl()
        setButton()
    }
    
    private func setScrollView() {
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeigh)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: viewWidth*CGFloat(backgroundImageArray.count), height: 0)
        self.view.addSubview(scrollView)
    }
    
    private func setImage() {
        for number in 0..<backgroundImageArray.count {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: viewWidth*CGFloat(number), y: 0, width: viewWidth, height: viewHeigh)
            imageView.image = UIImage(named: backgroundImageArray[number])
            scrollView.addSubview(imageView)
        }
    }
    
    private func setImageSize() {
        backgroundImageArray = []
        var screenResolution = UIScreen.main.nativeBounds.size
        print(screenResolution)
        if screenResolution == CGSize(width: 750, height: 1334) { // iPhone 6, 6s, 7, 8, SE2
            backgroundImageArray.append(contentsOf: ["1","2","3","4"])
        } else if screenResolution == CGSize(width: 1080, height: 2340) { // iPhone 12 mini, 13 mini
            backgroundImageArray.append(contentsOf: ["page2-1","page2-2","page2-3","page2-4"])
        } else if screenResolution == CGSize(width: 1242, height: 2208) { // iPhone 6, 6s, 7, 8 plus
            backgroundImageArray.append(contentsOf: ["page3-1","page3-2","page3-3","page3-4"])
        } else if screenResolution == CGSize(width: 1125, height: 2436) { // iPhone X, XS, 11 Pro
            backgroundImageArray.append(contentsOf: ["page4-1","page4-2","page4-3","page4-4"])
        } else if screenResolution == CGSize(width: 828, height: 1792) { // iPhone XR, 11
            backgroundImageArray.append(contentsOf: ["page5-1","page5-2","page5-3","page5-4"])
        } else if screenResolution == CGSize(width: 1170, height: 2532) { // iPhone 12, 13, 12 Pro, 13 Pro, 14
            backgroundImageArray.append(contentsOf: ["page6-1","page6-2","page6-3","page6-4"])
        } else if screenResolution == CGSize(width: 1242, height: 2688) { // iPhone XS, 11 Pro Max
            backgroundImageArray.append(contentsOf: ["page7-1","page7-2","page7-3","page7-4"])
        } else if screenResolution == CGSize(width: 1284, height: 2778) { // iPhone 12 Pro Max, 13 Pro Max, 14 plus
            backgroundImageArray.append(contentsOf: ["page8-1","page8-2","page8-3","page8-4"])
        } else if screenResolution == CGSize(width: 1179, height: 2556) { // 14pro
            backgroundImageArray.append(contentsOf: ["page8-1","page8-2","page8-3","page8-4"])
        } else if screenResolution == CGSize(width: 1284, height: 2796){ // 14Pro Max
            backgroundImageArray.append(contentsOf: ["page9-1","page9-2","page9-3","page9-4"])
        } else if screenResolution == CGSize(width: 768, height: 1024)||screenResolution == CGSize(width: 1536, height: 2048)||screenResolution == CGSize(width: 1620, height: 2160)||screenResolution == CGSize(width: 1668, height: 2224)||screenResolution == CGSize(width: 1640, height: 2360)||screenResolution == CGSize(width: 2048, height: 2732)||screenResolution == CGSize(width: 834, height: 1194){
            backgroundImageArray.append(contentsOf: ["ipad_1","ipad_2","ipad_3","ipad_4"])
        } else {
            backgroundImageArray.append(contentsOf: ["page9-1","page9-2","page9-3","page9-4"])
        }
    }
    
    private func setPageControl() {
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: (Int(viewWidth)-200)/2, y: Int(viewHeigh)-90, width: 200, height: 50)
        pageControl.numberOfPages = backgroundImageArray.count
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
    }
    
    private func setButton() {
        button = UIButton()
        button.frame = CGRect(x: Int(viewWidth)-95, y: Int(viewHeigh)-90, width: 60, height: 60)
        if pageControl.currentPage == backgroundImageArray.count-1 {
            button.setTitle("閉じる", for: .normal)
        } else {
            button.setTitle("次へ", for: .normal)
        }
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        button.addTarget(self, action: #selector(tappedButton(sender: )), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc private func tappedButton(sender: Any) {
        if pageControl.currentPage >= 0 && pageControl.currentPage < backgroundImageArray.count-1 {
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentOffset.x += self.viewWidth
            }
            pageControl.currentPage += 1
        } else if pageControl.currentPage == backgroundImageArray.count-1 {
            let user = Auth.auth().currentUser
            let userDefaults = UserDefaults.standard
            let firstLunchKey = "firstLunchKey"
            var keyStatus: Bool?
            keyStatus = userDefaults.bool(forKey: firstLunchKey)
            if fromSignUp == true {
                self.dismiss(animated: true, completion: nil)
            } else if keyStatus == true{
                userDefaults.set(false, forKey: firstLunchKey)
                let storyboard: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
                let nextVC = storyboard.instantiateViewController(withIdentifier: "tab")
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension PagingViewController: UIPageViewControllerDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
}
