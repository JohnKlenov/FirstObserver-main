//
//  UIViewController + extension.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.04.23.
//

import UIKit
// а что если несколько VC подписанных будут в памяти какое будет поведение?

// MARK: - UIAdaptivePresentationControllerDelegate
extension UIViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if #available(iOS 13, *) {
            //Call viewWillAppear only in iOS 13
            viewWillDisappear(true)
            viewWillAppear(true)
        }
    }
}


// MARK: - ViewController on screen
extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
}


// MARK: - hidden/show navigationBar
extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// Как установить заголовок с выравниванием по левому краю в элементе навигации iOS
extension UIViewController
{
    func setLeftAlignedNavigationItemTitle(text: String,
                                           color: UIColor,
                                           margin left: CGFloat)
    {
        let titleLabel = UILabel()
        titleLabel.textColor = color
        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.titleView = titleLabel
        
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        
        // NOTE: This always seems to be 0. Huh??
        let leftBarItemWidth = self.navigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                             constant: (leftBarItemWidth ?? 0) + left),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
    }
}
