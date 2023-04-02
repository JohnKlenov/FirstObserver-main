//
//  MainTabBarController.swift
//  FirstObserver
//
//  Created by Evgenyi on 28.03.23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 0.2)
        topline.backgroundColor = UIColor.black.cgColor
        self.tabBar.layer.addSublayer(topline)
        
    }
    
}
