//
//  NewOnboardPageViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.05.23.
//

import Foundation
import UIKit

class NewOnboardPageViewController: UIPageViewController {
    
    let presentScreenContents = R.Strings.OtherControllers.OnboardPage.presentScreenContents
    var currentIndex: Int?
    var pendingIndex: Int?
    var arrayVC: [OnboardViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupArray()
        delegate = self
        dataSource = self
        setViewControllers([arrayVC[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func setupArray() {
        presentScreenContents.forEach { message in
            let vc = OnboardViewController()
            vc.messageLabel.text = message
            arrayVC.append(vc)
        }
    }
    
    
}

extension NewOnboardPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = arrayVC.firstIndex(of: viewController as! OnboardViewController)!
                if currentIndex == 0 {
                    return nil
                }
                let previousIndex = abs((currentIndex - 1) % arrayVC.count)
                return arrayVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = arrayVC.firstIndex(of: viewController as! OnboardViewController)!
        if currentIndex == arrayVC.count-1 {
                    return nil
                }
                let nextIndex = abs((currentIndex + 1) % arrayVC.count)
                return arrayVC[nextIndex]
    }
    
    
}

extension NewOnboardPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstVC = pendingViewControllers.first {
            pendingIndex = arrayVC.firstIndex(of: firstVC as! OnboardViewController)!
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
                 currentIndex = pendingIndex
                 if let index = currentIndex {
                     arrayVC[index].pageControl.currentPage = index
//                     pageControl.currentPage = index
                 }
             }
    }
}
