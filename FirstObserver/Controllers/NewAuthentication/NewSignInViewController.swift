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
        textField.isSecureTextEntry = true
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
    
    let exitTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.backgroundColor = .darkGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2
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
    
    var signingIn = false {
        didSet {
            signInButton.setNeedsUpdateConfiguration()
        }
    }
    
    let signInButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
//    private let deleteImage: DeleteView = {
//        let view = DeleteView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = true
//        view.layer.cornerRadius = 10
//        return view
//    }()
//
//    let tapDeleteImageGestureRecognizer: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer()
//        recognizer.numberOfTapsRequired = 1
//        return recognizer
//    }()
    
    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    private let eyeButton = EyeButton()
    private var isPrivateEye = true
    private var buttonCentre: CGPoint!
    
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        passwordTextField.delegate = self
        emailTextField.delegate = self
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSignIn), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSignIn), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Actions
    @objc private func displayBookMarks() {
        let imageName = isPrivateEye ? "eye" : "eye.slash"
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        isPrivateEye.toggle()
    }
    
    @objc func gestureDidTap() {
        view.endEditing(true)
    }
    
    @objc func didTapDeleteImage(_ gestureRcognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSignInButton(_ sender: UIButton) {
        
        self.signingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("DispatchQueue.main.asyncAfter")
            self.signingIn = false
        }
        print("didTapSignInButton")
    }
    
    // этот селектор вызывается даже когда поднимается keyboard в SignUpVC(SignInVC не умерает когда поверх него ложится SignUpVC)
    @objc func keyboardWillHideSignIn(notification: Notification) {
        signInButton.center = buttonCentre
//        activityIndicator.center = button.center
    }
    
    // этот селектор вызывается даже когда поднимается keyboard в SignUpVC
    @objc func keyboardWillShowSignIn(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        signInButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 25 - signInButton.frame.height/2)
//
//        activityIndicator.center = button.center
        
    }
}


// MARK: - Setting Views
// Что бы не делать все методы private мы сделаем private extension.
private extension NewSignInViewController {
    func setupView() {
        setupPasswordTF()
        addActions()
        setupStackView()
        addSubViews()
        setupLayout()
    }
}


// MARK: - Setting
private extension NewSignInViewController {
    
    func addSubViews() {
        view.addGestureRecognizer(tapRootViewGestureRecognizer)
        view.addSubview(signInButton)
//        deleteImage.addGestureRecognizer(tapDeleteImageGestureRecognizer)
//        view.addSubview(deleteImage)
        view.addSubview(exitTopView)
        view.addSubview(signInLabel)
        view.addSubview(allStackView)
    }
    
    func addActions() {
        
        eyeButton.addTarget(self, action: #selector(displayBookMarks ), for: .touchUpInside)
        tapRootViewGestureRecognizer.addTarget(self, action: #selector(gestureDidTap))
        signInButton.addTarget(self, action: #selector(didTapSignInButton(_:)), for: .touchUpInside)
        
        signInButton.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = .white
                outgoing.font = UIFont.boldSystemFont(ofSize: 15)
                return outgoing
            }
            config?.showsActivityIndicator = self.signingIn
            config?.title = self.signingIn ? "Signing In..." : "Sign In"
            button.isUserInteractionEnabled = !self.signingIn
            button.configuration = config
        }
//        tapDeleteImageGestureRecognizer.addTarget(self, action: #selector(didTapDeleteImage(_:)))
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
    
    func setupPasswordTF() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }
}


// MARK: - Layout
private extension NewSignInViewController {
    func setupLayout() {
        
//        deleteImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
//        deleteImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        deleteImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        deleteImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        signInButton.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.7, height: 50)
        signInButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
        buttonCentre = signInButton.center
        
        exitTopView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        exitTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        exitTopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        signInLabel.topAnchor.constraint(equalTo: exitTopView.bottomAnchor, constant: 45).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        allStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 20).isActive = true
        allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    }
}


// MARK: - UITextFieldDelegate
extension NewSignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {return}
        eyeButton.isEnabled = !text.isEmpty
    }
}


