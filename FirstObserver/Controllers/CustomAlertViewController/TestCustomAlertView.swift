//
//  CustomAlertView.swift
//  FirstObserver
//
//  Created by Evgenyi on 15.07.23.
//

import Foundation
import UIKit

//class CustomAlertViewController:

//enum AlertType {
//    case success
//    case failed
//}

//class CustomAlertViewController: UIViewController {
//
//    private let containerView = UIView()
//    private let titleLabel = UILabel()
//
//    init(alertType: AlertType) {
//        super.init(nibName: nil, bundle: nil)
//        configureUI(alertType: alertType)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//    }
//
//    private func configureUI(alertType: AlertType) {
//        // Configure container view
//        containerView.backgroundColor = .white
//        containerView.layer.cornerRadius = 10.0
//        containerView.clipsToBounds = true
//        view.addSubview(containerView)
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        let centerXConstraint = containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        let centerYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: 200)
//        let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: 200)
//        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
//
//        // Configure title label
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        containerView.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let titleLabelMargin: CGFloat = 16
//        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: titleLabelMargin)
//        let titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -titleLabelMargin)
//        let titleLabelCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
//        NSLayoutConstraint.activate([titleLabelLeadingConstraint, titleLabelTrailingConstraint, titleLabelCenterYConstraint])
//
//        // Set alert type specific properties
//        switch alertType {
//        case .success:
//            containerView.backgroundColor = UIColor.green
//            titleLabel.text = "Success"
//        case .failed:
//            containerView.backgroundColor = UIColor.red
//            titleLabel.text = "Failed"
//        }
//    }
//}

class TestCustomAlertView: UIView {
    
    private let titleLabel = UILabel()
    
    init(alertType: AlertType) {
        super.init(frame: .zero)
        configureUI(alertType: alertType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(alertType: AlertType) {
        // Configure view
        backgroundColor = .white
        layer.cornerRadius = 10.0
        
        // Configure title label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelMargin: CGFloat = 16
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: titleLabelMargin)
        let titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -titleLabelMargin)
        let titleLabelCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate([titleLabelLeadingConstraint, titleLabelTrailingConstraint, titleLabelCenterYConstraint])
        
        // Set alert type specific properties
        switch alertType {
        case .success:
            backgroundColor = UIColor.green
            titleLabel.text = "Success"
        case .failed:
            backgroundColor = UIColor.red
            titleLabel.text = "Failed"
        }
    }
    
    func showAnimation() {
        alpha = 0.0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
            self.transform = .identity
        }, completion: nil)
    }
    
    func hideAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            completion?()
        })
    }
}




