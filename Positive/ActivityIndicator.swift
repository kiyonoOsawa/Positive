//
//  ActivityIndicator.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/10/09.
//

import Foundation
import UIKit

struct ActivityIndicator{
    static let shared = ActivityIndicator()
    let activityIndicatorView = UIActivityIndicatorView()
    func showIndicator(view: UIView){
        activityIndicatorView.center = view.center
        activityIndicatorView.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicatorView)
    }
}
