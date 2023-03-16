//
//  NewSignUpViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 13.03.23.
//

import Foundation
import UIKit

final class NewSignUpViewController: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .darkGray
        return label
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
    
    let reEnterPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Re-enter password "
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let nameTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Enter user name")
        textField.textContentType = .name
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Enter email")
        textField.textContentType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Enter password")
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let reEnterTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: "Enter password")
        textField.textContentType = .newPassword
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let separatorNameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .black
        return view
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
    
    let separatorReEnterPasswordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .black
        return view
    }()
    
    let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let reEnterPasswordStackView: UIStackView = {
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
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign Up"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let exitTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.backgroundColor = .darkGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2
        return view
    }()
    
    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    let signUpButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
        configuration.titleAlignment = .center
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .black.withAlphaComponent(0.9)
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
    private let eyePassswordButton = EyeButton()
    private let eyeRePassswordButton = EyeButton()
    private var isPrivateEye = true
    private var buttonCentre: CGPoint!
    
    var signingIn = false {
        didSet {
            signUpButton.setNeedsUpdateConfiguration()
        }
    }
    
    let managerFB = FBManager.shared
    var isInvalidSignIn = false
    weak var signInDelegate:NewSignUpViewControllerDelegate?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        reEnterTextField.delegate = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSignUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSignUp), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

        
    }
    
    
    // MARK: - Actions
    
    @IBAction func signUpTextFieldChanged(_ sender: UITextField) {
       
        switch sender {
        case emailTextField:
            separatorEmailView.backgroundColor = emailTextField.text?.isEmpty ?? true ? .red.withAlphaComponent(0.8) : .black
        case nameTextField:
            separatorNameView.backgroundColor = nameTextField.text?.isEmpty ?? true ? .red.withAlphaComponent(0.8) : .black
        case passwordTextField:
            separatorPasswordView.backgroundColor = passwordTextField.text?.isEmpty ?? true ? .red.withAlphaComponent(0.8) : .black
        case reEnterTextField:
            separatorReEnterPasswordView.backgroundColor = reEnterTextField.text?.isEmpty ?? true ? .red.withAlphaComponent(0.8) : .black
        default:
            return
        }
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let rePassword = reEnterTextField.text else {return}
        
        let isValid = !(name.isEmpty) && !(email.isEmpty) && !(password.isEmpty) && password == rePassword
        isEnabledSignUpButton(enabled: isValid)
    }
    
    @objc private func displayBookMarksSignUp() {
        
        let imageName = isPrivateEye ? "eye" : "eye.slash"
        passwordTextField.isSecureTextEntry.toggle()
        eyePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        reEnterTextField.isSecureTextEntry.toggle()
        eyeRePassswordButton.setImage(UIImage(systemName: imageName), for: .normal)
        isPrivateEye.toggle()
    }
    
    @objc func gestureSignUpDidTap() {
        view.endEditing(true)
    }
    
    @objc func didTapSignUpButton(_ sender: UIButton) {
        
        self.signingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("DispatchQueue.main.asyncAfter")
            self.signingIn = false
        }
    }
    
    @objc func keyboardWillHideSignUp(notification: Notification) {
        signUpButton.center = buttonCentre
    }
    
    @objc func keyboardWillShowSignUp(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        signUpButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 15 - signUpButton.frame.height/2)
    }

    deinit {
        print("Deinit NewSignUpViewController")
    }
}


// MARK: - Setting Views
private extension NewSignUpViewController {
    func setupView() {
        setupPasswordTF()
        addActions()
        setupStackView()
        addSubViews()
        setupLayout()
        isEnabledSignUpButton(enabled: false)
    }
}

// MARK: - Setting
private extension NewSignUpViewController {
    
    func addSubViews() {
        view.addGestureRecognizer(tapRootViewGestureRecognizer)
        view.addSubview(exitTopView)
        view.addSubview(signUpLabel)
        view.addSubview(allStackView)
        view.addSubview(signUpButton)
    }
    func addActions() {
        
        nameTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
        reEnterTextField.addTarget(self, action: #selector(signUpTextFieldChanged), for: .editingChanged)
        
        eyePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
        eyeRePassswordButton.addTarget(self, action: #selector(displayBookMarksSignUp), for: .touchUpInside)
        tapRootViewGestureRecognizer.addTarget(self, action: #selector(gestureSignUpDidTap))
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        signUpButton.configurationUpdateHandler = { [weak self] button in
            
            guard let signingIn = self?.signingIn else {return}
            var config = button.configuration
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = .white
                outgoing.font = UIFont.boldSystemFont(ofSize: 15)
                return outgoing
            }
            config?.imagePadding = 10
            config?.imagePlacement = .trailing
            config?.showsActivityIndicator = signingIn
            config?.title = signingIn ? "Signing In..." : "Sign In"
            button.isUserInteractionEnabled = !signingIn
            button.configuration = config
        }
    }
    
    
    func setupStackView() {
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        nameStackView.addArrangedSubview(separatorNameView)
        
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        emailStackView.addArrangedSubview(separatorEmailView)
        
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        passwordStackView.addArrangedSubview(separatorPasswordView)
        
        reEnterPasswordStackView.addArrangedSubview(reEnterPasswordLabel)
        reEnterPasswordStackView.addArrangedSubview(reEnterTextField)
        reEnterPasswordStackView.addArrangedSubview(separatorReEnterPasswordView)
        
        allStackView.addArrangedSubview(nameStackView)
        allStackView.addArrangedSubview(emailStackView)
        allStackView.addArrangedSubview(passwordStackView)
        allStackView.addArrangedSubview(reEnterPasswordStackView)
    }
    
    func setupPasswordTF() {
        passwordTextField.rightView = eyePassswordButton
        passwordTextField.rightViewMode = .always
        
        reEnterTextField.rightView = eyeRePassswordButton
        reEnterTextField.rightViewMode = .always
    }
    
    func isEnabledSignUpButton(enabled: Bool) {
        
        if enabled {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
    }
}

// MARK: - Layout
private extension NewSignUpViewController {
    func setupLayout() {
        
        exitTopView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        exitTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        exitTopView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        signUpLabel.topAnchor.constraint(equalTo: exitTopView.bottomAnchor, constant: 45).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        allStackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20).isActive = true
        allStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        allStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        signUpButton.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.7, height: 50)
        signUpButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
        buttonCentre = signUpButton.center
    }
}

// MARK: - UITextFieldDelegate
extension NewSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            reEnterTextField.becomeFirstResponder()
        case reEnterTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text = textField.text else {return}
        
        switch textField {
        case passwordTextField:
            eyePassswordButton.isEnabled = !text.isEmpty
        case reEnterTextField:
            eyeRePassswordButton.isEnabled = !text.isEmpty
        default:
            print("default textFieldDidChangeSelection")
            return
        }
    }
    
}


//        print("view height - \(view.frame.height)")
//        print("allStackView height - \(allStackView.frame.height)")
//        print("5+5+45+20+15 = 90")
//        print("signUpLabel.frame.height - \(signUpLabel.frame.height)")
//        print("signUpButton.frame.height - \(signUpButton.frame.height)")
//        print("all heightViews = \(90 + allStackView.frame.height + signUpLabel.frame.height + signUpButton.frame.height)")
