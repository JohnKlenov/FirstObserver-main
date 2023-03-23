//
//  NewProfileViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 20.03.23.
//

import Foundation
import UIKit

final class NewProfileViewController: UIViewController {
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let imageUser: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .darkGray
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.tintColor = .black
        textField.textContentType = .name
        textField.backgroundColor = .clear
        textField.placeholder = "enter you name"
        textField.text = "Johan Klenov"
        return textField
    }()
    
    let emailUserTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 17, weight: .medium)
        textField.tintColor = .black
        textField.textContentType = .emailAddress
        textField.backgroundColor = .clear
        textField.text = "klenovptz@mail.ru"
        return textField
    }()
    
    let infoUserStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.backgroundColor = .lightGray
        return stackView
    }()
   
    let signInSignUp: UIButton = {
    
        var configuration = UIButton.Configuration.gray()

        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        container.foregroundColor = UIColor.white
        configuration.attributedTitle = AttributedString("SignIn/SignUp", attributes: container)

        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        return grayButton
    }()
    
    let signOutButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        container.foregroundColor = UIColor.white
        configuration.attributedTitle = AttributedString("Sign Out", attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        return grayButton
    }()
    
    let deleteAccountButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 17)
        container.foregroundColor = UIColor.red
        configuration.attributedTitle = AttributedString("Delete Account", attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black
        var grayButton = UIButton(configuration: configuration)
        grayButton.translatesAutoresizingMaskIntoConstraints = false
        return grayButton
    }()
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
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
        configButton.title = "Cancel"
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
    
    let tapGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .black, tintColor: .white, title: "Profile", preferredLargeTitle: false)
        configureNavigationItem()
        setupStackView()
        imageUser.addGestureRecognizer(tapGestureRecognizer)
        addActions()
        
        
        view.addSubview(topView)
        view.addSubview(imageUser)
        view.addSubview(infoUserStackView)
        view.addSubview(buttonsStackView)
        
        
        imageUser.image = UIImage(named: "DefaultImage")
        setupConstraints()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    
   
    
    
    func configureNavigationItem() {
        
        navBarRightButton.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
        navBarLeftButton.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navBarLeftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarRightButton)
    }
    
    func setupStackView() {
        
        infoUserStackView.addArrangedSubview(userNameTextField)
        infoUserStackView.addArrangedSubview(emailUserTextField)
        
        buttonsStackView.addArrangedSubview(signInSignUp)
        buttonsStackView.addArrangedSubview(signOutButton)
        buttonsStackView.addArrangedSubview(deleteAccountButton)
        
    }
    
    func setupConstraints() {
        topView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        imageUser.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        imageUser.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        imageUser.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        let yConstraint = NSLayoutConstraint(item: imageUser, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.4, constant: 0)
        yConstraint.isActive = true
        infoUserStackView.topAnchor.constraint(equalTo: imageUser.bottomAnchor, constant: 20).isActive = true
        infoUserStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        infoUserStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    func addActions() {
        
        userNameTextField.addTarget(self, action: #selector(didChangeTextFieldNameOrEmail), for: .editingChanged)
        
        signInSignUp.addTarget(self, action: #selector(didTapsignInSignUp(_:)), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccount(_:)), for: .touchUpInside)
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapSingleGesture))
    }
    
    
    @objc func didTapsignInSignUp(_ sender: UIButton) {
        print("didTapsignInSignUp")
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        print("didTapSignOut")
    }
    
    @objc func didTapDeleteAccount(_ sender: UIButton) {
        print("didTapSignOut")
    }
    
    @objc func navBarRightButtonHandler() {
        navBarRightButton.configuration?.showsActivityIndicator.toggle()
        print("navBarRightButtonHandler()")
    }
    
    @objc func navBarLeftButtonHandler() {
        print("navBarLeftButtonHandler()")
    }
    
    @objc func didChangeTextFieldNameOrEmail() {
        print("didChangeTextFieldNameOrEmail()")
    }
    
    @objc func handleTapSingleGesture() {
        print("handleTapSingleGesture")
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

