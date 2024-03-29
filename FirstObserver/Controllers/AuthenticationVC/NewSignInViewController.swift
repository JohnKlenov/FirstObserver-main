//
//  NewSignInViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 10.03.23.
//

import Foundation
import UIKit

// NewSignInViewController BOSS he says Intern(NewProfileViewController) to do
protocol SignInViewControllerDelegate : AnyObject {
    func userIsPermanent()
}

// class final - это ускоряет диспетчеризация от него никто не будет в дальнейшем наследоваться.
final class NewSignInViewController: ParentNetworkViewController {
    
    let emailTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: R.Strings.AuthControllers.SignIn.placeholderEmailTextField)
        textField.textContentType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: AuthTextField = {
        let textField = AuthTextField(placeholder: R.Strings.AuthControllers.SignIn.placeholderPasswordTextField)
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let separatorEmailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = R.Colors.separator
        return view
    }()
    
    let separatorPasswordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = R.Colors.separator
        return view
    }()
    
    let exitTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 5).isActive = true
        view.backgroundColor = R.Colors.opaqueSeparator
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
    
    let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
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
        label.text = R.Strings.AuthControllers.SignIn.emailLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.label
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.AuthControllers.SignIn.passwordLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = R.Colors.label
        return label
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = R.Strings.AuthControllers.SignIn.signInLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = R.Colors.label
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
        configuration.baseBackgroundColor = R.Colors.systemPurple
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
    let signUpButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
       
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        container.foregroundColor = R.Colors.label
        configuration.attributedTitle = AttributedString(R.Strings.AuthControllers.SignIn.signUpButton, attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = R.Colors.systemFill
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
    let forgotPasswordButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
       
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 15)
        container.foregroundColor = R.Colors.label
        configuration.attributedTitle = AttributedString(R.Strings.AuthControllers.SignIn.forgotPasswordButton, attributes: container)
       
        configuration.titleAlignment = .center
        configuration.buttonSize = .mini
        var grayButton = UIButton(configuration: configuration)
        return grayButton
    }()
    
    let tapRootViewGestureRecognizer : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    private let eyeButton = EyeButton()
    private var isPrivateEye = true
    private var buttonCentre: CGPoint!
    
//    var isInvalidSignIn = false
    let managerFB = FBManager.shared
//    var cartProducts: [PopularProduct] = []
    
    // profileVC - userIsPermanentUpdateUI
    weak var delegate:SignInViewControllerDelegate?
    
    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.Colors.systemBackground
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
        let imageName = isPrivateEye ? R.Strings.AuthControllers.SignIn.imageSystemNameEye : R.Strings.AuthControllers.SignIn.imageSystemNameEyeSlash
        passwordTextField.isSecureTextEntry.toggle()
//        if let image = UIImage(named: imageName) {
//            let tintableImage = image.withRenderingMode(.alwaysTemplate)
//            eyeButton.setImage(tintableImage, for: .normal)
//        }
//        eyeButton.tintColor = R.Colors.label
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
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        //  signingIn - flag changed configuration button
        signingIn = true
        managerFB.signIn(email: email, password: password) { [weak self] (stateAuthError) in
            
            switch stateAuthError {
            case .success:
                self?.signingIn = false
                self?.isEnabledSignInButton(enabled: false)
                self?.userDidRegisteredNew()
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            case .failed:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "Something went wrong! Try again!", comletionHandler: {
//                    self?.isInvalidSignIn = true
                })
            case .invalidEmail:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "Invalid email", comletionHandler: {
                    self?.separatorEmailView.backgroundColor = R.Colors.systemRed
//                    self?.isInvalidSignIn = true
                })
            case .wrongPassword:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "Wrong password!", comletionHandler: {
                    self?.separatorPasswordView.backgroundColor = R.Colors.systemRed
//                    self?.isInvalidSignIn = true
                })
            case .userTokenExpired:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "You need to re-login to your account!", comletionHandler: {
//                    self?.isInvalidSignIn = true
                })
            case .invalidUserToken:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "You need to re-login to your account!", comletionHandler: {
//                    self?.isInvalidSignIn = true
                })
            case .requiresRecentLogin:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "You need to re-login to your account!", comletionHandler: {
//                    self?.isInvalidSignIn = true
                })
            case .tooManyRequests:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "Try again later!", comletionHandler: {
//                    self?.isInvalidSignIn = true
                })
            default:
                self?.signingIn = false
                self?.signInAlert(title: "Error", message: "Something went wrong! Try again!", comletionHandler: {
//                    self?.isInvalidSignIn = true
                })
            }
        }
    }
    
    @objc func didTapSignUpButton(_ sender: UIButton) {
        
        let signUpVC = NewSignUpViewController()
        signUpVC.signInDelegate = self
//        signUpVC.isInvalidSignIn = isInvalidSignIn
        signUpVC.presentationController?.delegate = self
        present(signUpVC, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapForgotPasswordButton(_ sender: UIButton) {

        sendPasswordResetAlert(title: "We will send you a link to reset your password", placeholder: "Enter your email") { [weak self] (enteredEmail) in
            self?.managerFB.sendPasswordReset(email: enteredEmail) { [weak self] stateAuthError in
                switch stateAuthError {
                case .success:
                    self?.showTopView(title: "Password was reset. Please check you email.", backgroundColor: R.Colors.systemGreen)
                case .failed:
                    self?.showTopView(title: "Something went wrong! Try again!", backgroundColor: R.Colors.systemRed)
                case .userTokenExpired:
                    self?.showTopView(title: "You need to re-login to your account!", backgroundColor: R.Colors.systemRed)
                case .invalidUserToken:
                    self?.showTopView(title: "You need to re-login to your account!", backgroundColor: R.Colors.systemRed)
                case .requiresRecentLogin:
                    self?.showTopView(title: "You need to re-login to your account!", backgroundColor: R.Colors.systemRed)
                case .tooManyRequests:
                    self?.showTopView(title: "Try again later!", backgroundColor: R.Colors.systemRed)
                case .invalidRecipientEmail:
                    self?.showTopView(title: "Incorrect email. Please try again!", backgroundColor: R.Colors.systemRed)
                case .missingEmail:
                    self?.showTopView(title: "Email was not provided!", backgroundColor: R.Colors.systemRed)
                case .invalidEmail:
                    self?.showTopView(title: "Email has an invalid format!", backgroundColor: R.Colors.systemRed)
                default:
                    self?.showTopView(title: "Something went wrong! Try again!", backgroundColor: R.Colors.systemRed)
                }
            }
        }
    }
    
    private func showTopView(title: String, backgroundColor: UIColor) {
        self.createTopView(textWarning: title, color: backgroundColor) { (alertView) in

            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {alertView.frame.origin = CGPoint(x: 0, y: -20)}) { (isFinished) in
                if isFinished {
                    UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {alertView.frame.origin = CGPoint(x: 0, y: -64)}, completion: nil)
                }
            }
        }
    }
    

    
    @IBAction func signInTextFieldChanged(_ sender: UITextField) {
        switch sender {
        case emailTextField:
            separatorEmailView.backgroundColor = Validators.isValidEmailAddr(strToValidate: emailTextField.text ?? "") ? R.Colors.separator : R.Colors.systemRed
        case passwordTextField:
            separatorPasswordView.backgroundColor = passwordTextField.text?.isEmpty ?? true ? R.Colors.systemRed : R.Colors.separator
//            Validators.isValidEmailAddr(strToValidate: passwordTextField.text ?? "")
        default:
            break
        }
//        separatorEmailView.backgroundColor = Validators.isValidEmailAddr(strToValidate: emailTextField.text ?? "") ? .black : .red.withAlphaComponent(0.8)
        
//        separatorPasswordView.backgroundColor = Validators.isValidEmailAddr(strToValidate: passwordTextField.text ?? "") ? .black : .red.withAlphaComponent(0.8)
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {return}
//        !(email.isEmpty)
//        Validators.isValidEmailAddr(strToValidate: email)
        let isValid = !(email.isEmpty) && !(password.isEmpty)
        isEnabledSignInButton(enabled: isValid)
    }
    
    // этот селектор вызывается даже когда поднимается keyboard в SignUpVC(SignInVC не умерает когда поверх него ложится SignUpVC)
    @objc func keyboardWillHideSignIn(notification: Notification) {
        signInButton.center = buttonCentre
    }
    
    // этот селектор вызывается даже когда поднимается keyboard в SignUpVC
    @objc func keyboardWillShowSignIn(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        signInButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 15 - signInButton.frame.height/2)
    }
    
//    deinit {
//        print("Deinit NewSignInViewController")
//        if isInvalidSignIn {
//            saveCartProductFBNew()
//        }
//    }
    
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
        isEnabledSignInButton(enabled: false)
    }
    
    func createTopView(textWarning:String, color: UIColor, comletionHandler: (AlertTopView) -> Void) {
        let alert = AlertTopView(frame: CGRect(origin: CGPoint(x: 0, y: -64), size: CGSize(width: self.view.frame.width, height: 64)))
        alert.setupAlertTopView(labelText: textWarning, backgroundColor: color)
        self.view.addSubview(alert)
        comletionHandler(alert)
    }
}


// MARK: - Setting
private extension NewSignInViewController {
    
    func addSubViews() {
        view.addGestureRecognizer(tapRootViewGestureRecognizer)
        view.addSubview(signInButton)
        view.addSubview(exitTopView)
        view.addSubview(signInLabel)
        view.addSubview(allStackView)
        view.addSubview(signUpStackView)
    }
    
    func addActions() {
        
        eyeButton.addTarget(self, action: #selector(displayBookMarks ), for: .touchUpInside)
        tapRootViewGestureRecognizer.addTarget(self, action: #selector(gestureDidTap))
        signInButton.addTarget(self, action: #selector(didTapSignInButton(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton(_:)), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton(_:)), for: .touchUpInside)
        passwordTextField.addTarget(self, action: #selector(signInTextFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(signInTextFieldChanged), for: .editingChanged)
        
        signInButton.configurationUpdateHandler = { [weak self] button in
            
            guard let signingIn = self?.signingIn else {return}
            var config = button.configuration
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = R.Colors.label
                outgoing.font = UIFont.systemFont(ofSize: 17, weight: .bold)
                return outgoing
            }
            config?.imagePadding = 10
            config?.imagePlacement = .trailing
            config?.showsActivityIndicator = signingIn
            config?.title = signingIn ? R.Strings.AuthControllers.SignIn.signInButtonProcess : R.Strings.AuthControllers.SignIn.signInButtonStart
            button.isUserInteractionEnabled = !signingIn
            button.configuration = config
        }
        
        
    }
    
    func setupStackView() {
        
        authEmailStackView.addArrangedSubview(emailLabel)
        authEmailStackView.addArrangedSubview(emailTextField)
        authEmailStackView.addArrangedSubview(separatorEmailView)
        
        authPasswordStackView.addArrangedSubview(passwordLabel)
        authPasswordStackView.addArrangedSubview(passwordTextField)
        authPasswordStackView.addArrangedSubview(separatorPasswordView)
        
        signUpStackView.addArrangedSubview(signUpButton)
        signUpStackView.addArrangedSubview(forgotPasswordButton)
        
        allStackView.addArrangedSubview(authEmailStackView)
        allStackView.addArrangedSubview(authPasswordStackView)
    }
    
    func setupPasswordTF() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
//        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    func isEnabledSignInButton(enabled: Bool) {
        
        if enabled {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
    }
}


// MARK: - Layout
private extension NewSignInViewController {
    func setupLayout() {
        
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
        allStackView.bottomAnchor.constraint(equalTo: signUpStackView.topAnchor, constant: -20).isActive = true
        
        signUpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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


// MARK: - SignUpViewControllerDelegate
extension NewSignInViewController: NewSignUpViewControllerDelegate {
    
//    func saveCartProductFBNew() {
//        managerFB.saveDeletedFromCart(products: cartProducts)
//        self.isInvalidSignIn = false
//    }
    
    func userDidRegisteredNew() {
        // это свойство не nil только из ProfileVC
        delegate?.userIsPermanent()
    }
}



// MARK: - Alert
private extension NewSignInViewController {
    
    func signInAlert(title:String, message:String, comletionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let  okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            comletionHandler()
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendPasswordResetAlert(title:String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let alertOK = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let textField = alertController.textFields?.first
            guard let text = textField?.text else {return}
            completionHandler(text)
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            ///
        }
        
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        
        present(alertController, animated: true, completion: nil)
    }
}




//    @objc func didTapForgotPasswordButton(_ sender: UIButton) {
//
//        sendPasswordResetAlert(title: "We will send you a link to reset your password", placeholder: "Enter your email") { [weak self] (enteredEmail) in
//            self?.managerFB.sendPasswordReset(email: enteredEmail) { [weak self] stateAuthError in
//                switch stateAuthError {
//                case .success:
//                    self?.createTopView(textWarning: "Password was reset. Please check you email.", color: R.Colors.systemGreen) { (alertView) in
//
//                        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {alertView.frame.origin = CGPoint(x: 0, y: -20)}) { (isFinished) in
//                            if isFinished {
//                                UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {alertView.frame.origin = CGPoint(x: 0, y: -64)}, completion: nil)
//                            }
//                        }
//                    }
//                case .failed:
//                    self?.createTopView(textWarning: "Incorrect email. Please try again.", color: R.Colors.systemRed) { (alertView) in
//
//                        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {alertView.frame.origin = CGPoint(x: 0, y: -20)}) { (isFinished) in
//                            if isFinished {
//                                // возможно придется скрыть cancel button
//                                UIView.animate(withDuration: 0.5, delay: 5, options: .curveEaseOut, animations: {alertView.frame.origin = CGPoint(x: 0, y: -64)}, completion: nil)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
