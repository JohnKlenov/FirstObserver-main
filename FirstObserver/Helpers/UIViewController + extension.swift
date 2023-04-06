//
//  UIViewController + extension.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.04.23.
//

import UIKit
// а что если несколько VC подписанных будут в памяти какое будет поведение?

// MARK: UIAdaptivePresentationControllerDelegate
extension UIViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if #available(iOS 13, *) {
            //Call viewWillAppear only in iOS 13
            viewWillDisappear(true)
            viewWillAppear(true)
//            viewDidDisappear(true)
            
        }
    }
//    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
//        if #available(iOS 13, *) {
//            //Call viewWillAppear only in iOS 13
//            viewWillDisappear(true)
//        }
//
//    }
    
}

extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
}

