//
//  OnboardPageViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 6.05.23.
//


import UIKit

class OnboardViewController: UIViewController {
    
    
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
    
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.backgroundColor = .clear
        label.textColor = R.Colors.label
        label.numberOfLines = 0
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
    
    weak var pageVC:OnboardPageViewControllerDelegate?
    var presenText = ""
    var currentPage = 0
    var numberOfPages = 0
    
    // MARK: - lifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.systemBackground
        print("currentPage - \(currentPage)")
        
        setupViews()
        setupConstraints()
        hiddenNextButton()
//        pageControl.currentPage = currentPage
//        pageControl.numberOfPages = numberOfPages
//        print("pageControl.currentPage - \(pageControl.currentPage)")
        
//        messageLabel.text = presenText
    }
    
    @objc func nextPage(_ sender: UIButton) {
        currentPage += 1
        pageVC?.nextPage(currentPage)
    }
    
    @objc func getStarted(_ sender: UIButton) {
        currentPage += 1
        pageVC?.nextPage(currentPage)
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(nextButton)
        view.addSubview(getStartedButton)
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50), titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50), messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), messageLabel.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -150), getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), getStartedButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20), pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor), pageControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50), nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30), nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20)])
    }
    
    private func hiddenNextButton() {
        if currentPage == R.Strings.OtherControllers.OnboardPage.presentScreenContents.count-1 {
            nextButton.isHidden = true
            getStartedButton.isHidden = false
        }
    }
    
    
    
}


