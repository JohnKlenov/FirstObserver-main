//
//  PresentViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.05.23.
//

import UIKit


// PresentViewController загружается лишь один раз в жизненом цикле приложения при первом старте
// делать это следует поместив его в window в AppDelegate по флагу в UserDefaults а затем
protocol PresentViewControllerDelegate: AnyObject {
    func hiddenNextButton()
    func pageChangedTo(index: Int)
}

class PresentViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.text = R.Strings.OtherControllers.OnboardPage.titleLabel
        label.numberOfLines = 1
        return label
    }()
    
    let nextButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = R.Colors.systemPurple
        
        configuration.attributedTitle = AttributedString(R.Strings.OtherControllers.OnboardPage.nextButton, attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemFill

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(nextPage(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let getStartedButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = R.Colors.systemPurple
        
        configuration.attributedTitle = AttributedString(R.Strings.OtherControllers.OnboardPage.getStartedButton, attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = R.Colors.systemFill

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        grayButton.isHidden = true
        grayButton.addTarget(self, action: #selector(getStarted(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = R.Strings.OtherControllers.OnboardPage.presentScreenContents.count
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = R.Colors.systemPurple
        control.pageIndicatorTintColor = R.Colors.systemGray
        return control
    }()
    
    let childVC = ChildPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        childVC.presentDelegate = self
        addChild(childVC)
        setupViews()
        childVC.didMove(toParent: self)
        setupConstraints()
        
    }
    
    @objc func nextPage(_ sender: UIButton) {
        childVC.nextPage(index: pageControl.currentPage + 1)
    }
    
    @objc func getStarted(_ sender: UIButton) {
        print("func getStarted")
//        NewHomeViewController.userDefaults.set(true, forKey: "isFinishPresentation")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(childVC.view)
        view.addSubview(nextButton)
        view.addSubview(getStartedButton)
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50), titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50), childVC.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0), childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0), childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0), childVC.view.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: 0), getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), getStartedButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20), pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor), pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50), nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20)])
    }
    
    deinit {
        print("deinit PresentViewController")
    }
}

extension PresentViewController: PresentViewControllerDelegate {
    
    func hiddenNextButton() {
        nextButton.isHidden = true
        getStartedButton.isHidden = false
    }
    
    func pageChangedTo(index: Int) {
        pageControl.currentPage = index
    }
}
