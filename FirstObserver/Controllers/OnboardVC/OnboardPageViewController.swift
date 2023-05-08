//
//  OnboardPageViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 7.05.23.
//

import UIKit


protocol OnboardPageViewControllerDelegate: AnyObject {
    func nextPage(_ index:Int)
}

class OnboardPageViewController: UIPageViewController {
    
    let presentScreenContents = R.Strings.OtherControllers.OnboardPage.presentScreenContents
    var currentIndex: Int?
    var pendingIndex: Int?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupPageControl()
        dataSource = self
        delegate = self
        if let contentPageVC = showViewControllerAtIndex(0) {
            contentPageVC.pageVC = self
            setViewControllers([contentPageVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
//    func setupPageControl(){
//            UIPageControl.appearance(whenContainedInInstancesOf: [PageViewController.self]).currentPageIndicatorTintColor = R.Colors.systemPurple
//            UIPageControl.appearance(whenContainedInInstancesOf: [PageViewController.self]).pageIndicatorTintColor = R.Colors.systemGray
//        }
    
    func showViewControllerAtIndex(_ index: Int) -> OnboardViewController? {
        
        guard index >= 0 && index < presentScreenContents.count else {
            
            // save true for UserDefaults if index < presentScreenContents.count
            
            NewHomeViewController.userDefaults.set(true, forKey: "isFinishPresentation")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            
            return nil
        }
        
        let contentPageViewController = OnboardViewController()
//        contentPageViewController.messageLabel.text = presentScreenContents[index]
//        contentPageViewController.pageControl.numberOfPages = presentScreenContents.count
//        contentPageViewController.pageControl.currentPage = index
        contentPageViewController.presenText = presentScreenContents[index]
//        contentPageViewController.numberOfPages = presentScreenContents.count
        contentPageViewController.currentPage = index
        
        return contentPageViewController
    }
    
    deinit {
        print("PageViewController is dead!")
    }
}




extension OnboardPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! OnboardViewController).currentPage
        guard pageNumber > 0 else { return nil }
        pageNumber -= 1
        return showViewControllerAtIndex(pageNumber)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! OnboardViewController).currentPage
        pageNumber += 1
        return showViewControllerAtIndex(pageNumber)
    }

}

extension OnboardPageViewController: UIPageViewControllerDelegate {
    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        var desiredIndex: Int = 0
//        for (index, value) in presentScreenContents.enumerated() {
//            if let vc = pageViewController.children.first as? OnboardViewController, vc.messageLabel.text == value {
//                desiredIndex = index
//            }
//        }
//        return desiredIndex
//    }
//
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return presentScreenContents.count
//    }
//
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
                currentIndex = pendingIndex
                if let index = currentIndex {
//                    pageControl.currentPage = index
                }
            }
        }
//        var desiredIndex: Int = 0
//        for (index, value) in presentScreenContents.enumerated() {
//            if let vc = pageViewController.children.first as? OnboardViewController, vc.messageLabel.text == value {
//                print("didFinishAnimating - \(index)")
//                vc.pageControl.currentPage = index
////                desiredIndex = index
//            }
//        }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        guard let VC = pendingViewControllers.first, let nextVC = VC as? OnboardViewController else {return}
//        nextVC.currentPage =
//        pendingIndex = pendingViewControllers.first
        if let vc = pendingViewControllers.first as? OnboardViewController {
            pendingIndex = vc.currentPage
        }
}
}

extension OnboardPageViewController: OnboardPageViewControllerDelegate {
    
    func nextPage(_ index: Int) {
        if let nextPageVC = showViewControllerAtIndex(index) {
            nextPageVC.pageVC = self
            setViewControllers([nextPageVC], direction: .forward, animated: true, completion: nil)
        }
    }

}
