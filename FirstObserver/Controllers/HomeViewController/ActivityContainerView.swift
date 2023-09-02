//
//  ActivityContainerView.swift
//  FirstObserver
//
//  Created by Evgenyi on 28.05.23.
//


import UIKit

class ActivityContainerView: UIView {
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
//        loader.color = R.Colors.systemPurple
        loader.color = R.Colors.systemPurple
//        loader.isHidden = true
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.Colors.opaqueSeparator
        addSubview(loader)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([loader.heightAnchor.constraint(equalToConstant: 50), loader.widthAnchor.constraint(equalToConstant: 50), loader.centerXAnchor.constraint(equalTo: centerXAnchor), loader.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    func startAnimating() {
        loader.startAnimating()
    }
    
    func isAnimating(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(loader.isAnimating)
    }
    
    func stopAnimating() {
        loader.stopAnimating()
    }
}
