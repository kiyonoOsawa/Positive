//
//  TabBar.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/07/23.
//

import UIKit

class TabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 88
        return sizeThatFits;
    }
}
