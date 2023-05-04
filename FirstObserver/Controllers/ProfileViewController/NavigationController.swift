//
//  NavigationController.swift
//  FirstObserver
//
//  Created by Evgenyi on 22.03.23.
//

import Foundation
import UIKit

class NewProfileNavigationController: UINavigationController {
    
   
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NewProfileNavigationController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("NewProfileNavigationController viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("NewProfileNavigationController viewDidDisappear")
    }
    
}
