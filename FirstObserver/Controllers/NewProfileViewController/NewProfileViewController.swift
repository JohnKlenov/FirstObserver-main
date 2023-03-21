//
//  NewProfileViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 20.03.23.
//

import Foundation
import UIKit

final class NewProfileViewController: UIViewController {
    
    private let topConteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let testImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    let navBarRightButton: UIButton = {
        var configButton = UIButton.Configuration.plain()
        configButton.title = "Edit"
        configButton.baseForegroundColor = .systemPurple
        configButton.titleAlignment = .trailing
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let navBarLeftButton: UIButton = {
        var configButton = UIButton.Configuration.plain()
        configButton.title = "Edit"
        configButton.baseForegroundColor = .systemPurple
        configButton.titleAlignment = .trailing
        configButton.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incomig in

            var outgoing = incomig
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
        }
        var button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .black, tintColor: .white, title: "Profile", preferredLargeTitle: false)
        setupNavigationBar()
    
        
        
        //        topConteinerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        //        topConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        //        topConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        //        topConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        testImageView.frame  = CGRect(x: 0, y: 0, width: view.frame.height * 0.2, height: view.frame.height * 0.2)
//        testImageView.center = CGPoint(x: topConteinerView.center.x, y: topConteinerView.frame.height)
    }
    
    
    
    @objc func navBarRightButtonHandler() {
        navBarLeftButton.configuration?.showsActivityIndicator = true
        print("navBarRightButtonHandler()")
    }
    
    @objc func navBarLeftButtonHandler() {
        navBarLeftButton.configuration?.showsActivityIndicator = false
        print("navBarLeftButtonHandler()")
    }
    
    
    func setupNavigationBar() {
        
        navBarRightButton.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
        navBarLeftButton.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBarLeftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarRightButton)

    }
    
}

extension UIViewController {
func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = title
    }
}}

