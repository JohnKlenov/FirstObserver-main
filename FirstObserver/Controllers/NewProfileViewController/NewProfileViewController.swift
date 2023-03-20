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
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let testImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    var top: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(topConteinerView)
        view.addSubview(testImageView)
        view.backgroundColor = .white
        
        
        
        topConteinerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testImageView.frame  = CGRect(x: 0, y: 0, width: view.frame.height * 0.2, height: view.frame.height * 0.2)
        testImageView.center = CGPoint(x: topConteinerView.center.x, y: topConteinerView.frame.height)
    }
}
