//
//  CartView.swift
//  FirstObserver
//
//  Created by Evgenyi on 16.02.23.
//

import UIKit

class CartView: UIView {

    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "cart")
        image.contentMode = .scaleAspectFit
//        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "You cart is empty yet"
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = .black.withAlphaComponent(0.8)
        label.text = "The basket is waiting to be filed!"
        label.numberOfLines = 0
        return label
    }()
    
    let stackViewForLabel: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()
    
    let catalogButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = UIColor.white
        
        configuration.attributedTitle = AttributedString("Go to the catalog", attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(catalogButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let logInButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = UIColor.white
        
        configuration.attributedTitle = AttributedString("LogIn", attributes: container)
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)

        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        
        grayButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
        
        return grayButton
    }()
    
    let stackViewForButton: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        layer.cornerRadius = 10
        configureStackView()
        addSubview(imageView)
        addSubview(stackViewForLabel)
        addSubview(stackViewForButton)
        setupConstraints()
        
        
    }
    
    private func configureStackView() {
        let arrayLabel = [titleLabel, subtitleLabel]
        arrayLabel.forEach { view in
            stackViewForLabel.addArrangedSubview(view)
        }
        
        let arrayButton = [catalogButton, logInButton]
        arrayButton.forEach { view in
            stackViewForButton.addArrangedSubview(view)
        }
    }
    
    private func setupConstraints() {
        
        let topImageViewCnstr = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40)
//        topImageViewCnstr.priority = UILayoutPriority(999)
        topImageViewCnstr.isActive = true
        
        let centerYImageViewCnstr = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerYImageViewCnstr.isActive = true
        
        let widthImageViewCnstr = imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/5)
        widthImageViewCnstr.isActive = true
        
        let heightImageViewCnstr = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        heightImageViewCnstr.isActive = true
        
        // stackViewForLabel
        let topStackForLabelCnstr = stackViewForLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
        topStackForLabelCnstr.isActive = true
        
        let trailingStackForLabelCnstr = stackViewForLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        trailingStackForLabelCnstr.isActive = true
        
        let leadingStackForLabelCnstr = stackViewForLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        leadingStackForLabelCnstr.isActive = true
        
        // stackForButton
        
        let topStackForButtonCnstr = stackViewForButton.topAnchor.constraint(equalTo: stackViewForLabel.bottomAnchor, constant: 10)
        topStackForButtonCnstr.isActive = true
        
        let trailingStackForButtonCnstr = stackViewForButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        trailingStackForButtonCnstr.isActive = true
        
        let leadingStackForButtonCnstr = stackViewForButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        leadingStackForButtonCnstr.isActive = true
        
        let bottomStackForButtonCnstr = stackViewForButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
//        bottomStackForButtonCnstr.priority = UILayoutPriority(999)
        bottomStackForButtonCnstr.isActive = true
    }

    
    
    @objc func catalogButtonPressed(_ sender: UIButton) {
        
    }
    
    @objc func logInButtonPressed(_ sender: UIButton) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
