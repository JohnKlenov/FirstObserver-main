//
//  NewSignInViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 10.03.23.
//

import Foundation
import UIKit

// class final - это ускоряет диспетчеризация от него никто не будет в дальнейшем наследоваться.
final class NewSignInViewController: UIViewController {
    
    let emailTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Enter email")
        textField.textContentType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Enter password")
        textField.textContentType = .password
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let separatorEmailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .black
        return view
    }()
    
    let separatorPasswordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .black
        return view
    }()
    
    let authEmailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let authPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign In"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let tapGestureRecognizer : UITapGestureRecognizer = {
        
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
//        gesture.addTarget(self, action: #selector(gestureDidTap))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tapGestureRecognizer.addTarget(self, action: #selector(gestureDidTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        setupView()
    }
}

// Что бы не делать все методы private мы сделаем private extension.
private extension NewSignInViewController {
    func setupView() {
        addSubViews()
        setupLayout()
    }
}

// Setting
private extension NewSignInViewController {
    
    func addSubViews() {
        setupStackView()
        view.addSubview(signInLabel)
        view.addSubview(allStackView)
    }
    
    func setupStackView() {
        
        authEmailStackView.addArrangedSubview(emailLabel)
        authEmailStackView.addArrangedSubview(emailTextField)
        authEmailStackView.addArrangedSubview(separatorEmailView)
        
        authPasswordStackView.addArrangedSubview(passwordLabel)
        authPasswordStackView.addArrangedSubview(passwordTextField)
        authPasswordStackView.addArrangedSubview(separatorPasswordView)
        
        allStackView.addArrangedSubview(authEmailStackView)
        allStackView.addArrangedSubview(authPasswordStackView)
    }
}

// Layaut
private extension NewSignInViewController {
    func setupLayout() {
        
        signInLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        allStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 20).isActive = true
        allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    }
}

extension NewSignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewSignInViewController {
    
    @objc func gestureDidTap() {
        view.endEditing(true)
    }
}

