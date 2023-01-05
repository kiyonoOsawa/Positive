//
//  PagingViewController.swift
//  Positive
//
//  Created by 大澤清乃 on 2023/01/05.
//

import UIKit

class PagingViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var button: UIButton!
    var viewWidth: CGFloat!
    var viewHeigh: CGFloat!
    // 画像の文字列の配列
    let backgroundImageArray: [String] = ["page1", "page2", "page3", "page4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth = self.view.frame.width
        viewHeigh = self.view.frame.height
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
    
    private func setPageControl() {
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: (Int(viewWidth)-200)/2, y: Int(viewHeigh)-150, width: 200, height: 50)
        pageControl.numberOfPages = backgroundImageArray.count
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
    }
    
    private func setButton() {
        button = UIButton()
        button.frame = CGRect(x: Int(viewWidth)-100, y: Int(viewHeigh)-180, width: 60, height: 60)
        button.setTitle("次へ", for: .normal)
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
            self.dismiss(animated: true, completion: nil)
        }
    }
}
