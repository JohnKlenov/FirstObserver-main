//
//  CustomAlertView.swift
//  FirstObserver
//
//  Created by Evgenyi on 15.07.23.
//

import Foundation
import UIKit

enum AlertType {
    case success
    case failed
}

class CustomAlertView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.label
        return label
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.opaqueSeparator
        view.layer.cornerRadius = 10
        return view
    }()
    
    init(alertType: AlertType, frame: CGRect) {
        super.init(frame: frame)
        configureUI(alertType: alertType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(alertType: AlertType) {
        // Configure view
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        backgroundColor = .clear
        containerView.addSubview(titleLabel)
        addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        // Set alert type specific properties
        switch alertType {
        case .success:
            titleLabel.text = "Success"
        case .failed:
            titleLabel.text = "Failed"
        }
    
        showAnimation {
            self.removeFromSuperview()
        }
}
    
    func showAnimation(completion: (() -> Void)? = nil) {
        containerView.alpha = 0.0
        containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.containerView.alpha = 1.0
            self.containerView.transform = .identity
        } completion: { isFinished in
            UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseInOut) {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.containerView.alpha = 0.0
                self.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } completion: { isFinished in
                completion?()
            }
        }
    }
}
