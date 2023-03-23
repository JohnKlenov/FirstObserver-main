//
//  NewProfileViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 20.03.23.
//

import Foundation
import UIKit
import Firebase

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
    
    private var addedToCardProducts: [PopularProduct] = []
    private var isStateEditButton = true
    private var isAnimateDeleteButtonAnonUser = false
    
    private let encoder = JSONEncoder()
    private var imageIsChanged = false
    private var imageData: Data?
    private var imageReturn: UIImage?
    
    // MARK: FB property
    let managerFB = FBManager.shared
    private var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managerFB.userListener { [weak self] (user) in
            self?.currentUser = user

            if let user = user, !user.isAnonymous {
                self?.userIsPermanentUpdateUI(user)
            } else {
                self?.UserIsAnonymousUpdateUI()
            }
        }
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.addedToCardProducts = []
    }
    
    
    
    
    // MARK: - helper methods for func managerFB.updateProfileInfo() -

    private func failedUpdateImage() {
        navBarRightButton.configuration?.showsActivityIndicator = false
        switchSaveButton(isSwitch: false)
        if imageIsChanged {
            imageData = nil
            imageUser.image = imageReturn
            imageIsChanged = false
            imageReturn = nil
        }
    }
    private func successUpdateImage() {
        if imageIsChanged {
//                cacheImageRemoveMemoryAndDisk()
            managerFB.cacheImageRemoveMemoryAndDisk(imageView: imageUser)
            imageIsChanged = false
            imageData = nil
            imageReturn = nil
        }
    }

    private func failedUpdateName() {
        self.userNameTextField.text = self.currentUser?.displayName
    }

    
    // MARK: - helper methods -

    private func userIsPermanentUpdateUI(_ user:User) {
        print("$$$$$$private func userIsPermanentUpdateUI")
        print("user.displayName - \(String(describing: user.displayName))")
        navBarRightButton.isHidden = false
        emailUserTextField.isHidden = false
        emailUserTextField.text = user.email
        userNameTextField.text = user.displayName
        navBarLeftButton.isHidden = true
        userNameTextField.isUserInteractionEnabled = false
        emailUserTextField.isUserInteractionEnabled = false
        imageUser.isUserInteractionEnabled = false

        signOutButton.isHidden = false
        deleteAccountButton.isHidden = false

        if let photoURL = user.photoURL?.absoluteString {
            imageUser.fetchingImageWithPlaceholder(url: photoURL, placeholder: "DefaultImage")
//                let urlRef = storage.reference(forURL: photoURL)
//                imageUser.sd_setImage(with: urlRef, maxImageSize: 1024*1024, placeholderImage: UIImage(named: "DefaultImage"), options: .refreshCached) { (image, error, cashType, storageRef) in
//                    self.urlRefDelete = storageRef
//                    if error != nil {
//                        self.imageUser.image = UIImage(named: "DefaultImage")
//                    }
//                }
        } else {
            self.imageUser.image = UIImage(named: "DefaultImage")
        }
    }

    private func UserIsAnonymousUpdateUI() {
        navBarRightButton.isHidden = true
        navBarLeftButton.isHidden = true
        userNameTextField.text = "User is anonymous"
        userNameTextField.isUserInteractionEnabled = false
        imageUser.image = UIImage(named: "DefaultImage")
        imageUser.isUserInteractionEnabled = false
        emailUserTextField.isHidden = true
        signInSignUp.isHidden = false
        signOutButton.configuration?.showsActivityIndicator = false
        if isAnimateDeleteButtonAnonUser {
            print("if isAnimateDeleteButtonAnonUser")
            UIView.animate(withDuration: 0.2) {
                self.signOutButton.isHidden = true
                self.deleteAccountButton.isHidden = true
                self.isAnimateDeleteButtonAnonUser = false
            }
        } else {
            signOutButton.isHidden = true
            deleteAccountButton.isHidden = true
        }

    }
    
    private func startRemoveAvatarUpdateUI() {
//        editOrDoneButton.configuration?.title = ""
        navBarRightButton.configuration?.showsActivityIndicator = true
        navBarRightButton.isUserInteractionEnabled = false
    }

    private func endRemoveAvatarUpdateUI() {
        self.navBarRightButton.configuration?.showsActivityIndicator = false
        self.stateEditSaveButton(isSwitch: self.isStateEditButton)
        self.setupAlert(title: "Success", message: "Profile avatar is delete!")
        self.imageIsChanged = false
    }

    private func failedRemoveAvatarUpdateUI() {
        self.navBarRightButton.configuration?.showsActivityIndicator = false
        self.switchSaveButton(isSwitch: false)
        self.setupAlert(title: "Error", message: "Failed to delete profile avatar")
    }
    
    private func isValidTextField(comletion: (Bool) -> Void) {
        // logic valid email need not
        guard let email = emailUserTextField.text, let name = userNameTextField.text, let emailUser = currentUser?.email else { return }
        let isValid = (!(email.isEmpty) && email != emailUser) || (!(name.isEmpty) && name != currentUser?.displayName)
        comletion(isValid)
    }
    
    private func stateEditSaveButton(isSwitch: Bool) {
         isSwitch ? switchSaveButton(isSwitch: !isSwitch) : switchEditButton(isSwitch: !isSwitch)
         self.navBarLeftButton.isHidden = !isSwitch
         self.userNameTextField.isUserInteractionEnabled = isSwitch
         self.imageUser.isUserInteractionEnabled = isSwitch
         self.isStateEditButton = !isSwitch
    }

    private func switchSaveButton(isSwitch: Bool) {
        navBarRightButton.configuration?.title = "Save"
        navBarRightButton.configuration?.baseForegroundColor = isSwitch ? .systemPurple : .lightGray
        navBarRightButton.isUserInteractionEnabled = isSwitch ? true : false
    }

    private func switchEditButton(isSwitch: Bool) {
        navBarRightButton.configuration?.title = "Edit"
        navBarRightButton.configuration?.baseForegroundColor = isSwitch ? .systemPurple : .lightGray
        navBarRightButton.isUserInteractionEnabled = isSwitch ? true : false
    }
    
    private func getFetchDataHVC() {

        guard let tabBarVCs = tabBarController?.viewControllers else { return }
        tabBarVCs.forEach { (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.topViewController as? NewHomeViewController {
                    self.addedToCardProducts = homeVC.cardProducts
                }
            }
        }
    }
    
    // MARK: - FB methods -


    private func saveRemuveCartProductFB() {

        // i think here error - !currentUser.isAnonymous and setValue(["permanentUser":uid])
        if let currentUser = currentUser, !currentUser.isAnonymous {
//                let uid = currentUser.uid

//                let refFBR = Database.database().reference()
//                refFBR.child("usersAccaunt/\(uid)").setValue(["uidAnonymous":uid])
            managerFB.addUidFromCurrentUserAccount()
            var removeCartProduct: [String:AddedProduct] = [:]

            addedToCardProducts.forEach { (cartProduct) in
                let productEncode = AddedProduct(product: cartProduct)
                print("cartProduct - \(productEncode)")
                removeCartProduct[cartProduct.model] = productEncode
            }

            removeCartProduct.forEach { (addedProduct) in
                do {
                    let data = try encoder.encode(addedProduct.value)
                    let json = try JSONSerialization.jsonObject(with: data)
                    managerFB.addProductsToANonRemoteUser(products: [addedProduct.key:json])
//                        let ref = Database.database().reference(withPath: "usersAccaunt/\(uid)/AddedProducts")
//                        ref.updateChildValues([addedProduct.key:json])

                } catch {
                    print("an error occured", error)
                }
            }
        }
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
        
        getFetchDataHVC()
        let signInVC = NewSignInViewController()
        signInVC.cardProducts = addedToCardProducts
        signInVC.profileDelegate = self
        signInVC.presentationController?.delegate = self
        present(signInVC, animated: true, completion: nil)
        
//        if segue.identifier == "signInVCfromProfile" {
//            getFetchDataHVC()
//            let destination = segue.destination as! SignInViewController
//            destination.addedToCardProducts = self.addedToCardProducts
//            destination.profileDelegate = self
//        }
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        
        isAnimateDeleteButtonAnonUser = true
        signOutButton.configuration?.showsActivityIndicator = true

        managerFB.signOut { (stateCallback) in

            switch stateCallback {
            case .success:
                setupAlert(title: "Success", message: "You are logged out!")
            case .failed:
                signOutButton.configuration?.showsActivityIndicator = false
                isAnimateDeleteButtonAnonUser = false
                setupAlert(title: "Failed SignOut", message: "Something went wrong! Try again!")
            }
        }
        print("didTapSignOut")
    }
    
    @objc func didTapDeleteAccount(_ sender: UIButton) {
        
        getFetchDataHVC()
        setupDeleteAlert(title: "Warning", message: "Deleting your account will permanently lose your data!") { isDelete in

            if isDelete {
                self.isAnimateDeleteButtonAnonUser = true
//                     удаляем корзину user и в случае не успеха deleteAccaunt должны ее вернуть
                self.managerFB.deleteCurrentUserProducts()
                self.deleteAccountButton.configuration?.showsActivityIndicator = true

                self.managerFB.deleteAccaunt { (stateCallback) in
                    switch stateCallback {

                    case .success:
                        self.deleteAccountButton.configuration?.showsActivityIndicator = false
                        self.managerFB.removeAvatarFromDeletedUser()
                        self.setupAlert(title: "Success", message: "Current accaunt delete!")
                    case .failed:
                        // сохранить данные обратно в корзину?
//                            saveRemuveCartProductFB

                        self.deleteAccountButton.configuration?.showsActivityIndicator = false
                        self.isAnimateDeleteButtonAnonUser = false
                        self.setupFailedAlertDeleteAccount(title: "Failed", message: "Something went wrong. Try again!")
                    case .failedRequiresRecentLogin:
                        self.deleteAccountButton.configuration?.showsActivityIndicator = false
                        self.wrapperOverDeleteAlert(title: "Error", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
                    }
                }

            } else {
                self.isAnimateDeleteButtonAnonUser = false
                print("Cancel delete Accaunt!")
            }
        }
        print("didTapSignOut")
    }
    
    @objc func navBarRightButtonHandler() {
//        navBarRightButton.configuration?.showsActivityIndicator.toggle()
        if isStateEditButton {
            stateEditSaveButton(isSwitch: isStateEditButton)
        } else {
            navBarRightButton.configuration?.title = ""
            navBarRightButton.configuration?.showsActivityIndicator = true
            navBarRightButton.isUserInteractionEnabled = false

            let image = imageIsChanged ? imageData : nil
            // if currentUser = nil ???
            let name = userNameTextField.text != currentUser?.displayName ? userNameTextField.text : nil

            managerFB.updateProfileInfo(withImage: image, name: name) { (state) in

                switch state {

                case .success:
                    self.navBarRightButton.configuration?.showsActivityIndicator = false
                    self.stateEditSaveButton(isSwitch: self.isStateEditButton)
                    self.setupAlert(title: "Success", message: "Data changed!")
                    self.successUpdateImage()

                case .failed(image: let image, name: let name):
                    if let image = image, let name = name {
                        if image && name {
                            self.failedUpdateImage()
                            self.failedUpdateName()
                            self.setupAlert(title: "Error", message: "Something went wrong! Try again!")
                        } else if image {
                            self.failedUpdateImage()
                            self.setupAlert(title: "Error", message: "Avatar not saved! Try again!")

                        } else if name {

                            self.navBarRightButton.configuration?.showsActivityIndicator = false
                            self.switchSaveButton(isSwitch: false)
                            self.failedUpdateName()
                            self.successUpdateImage()
                            self.setupAlert(title: "Error", message: "Name not saved! Try again!")
                        }
                    } else if let name = name, name {
                        self.navBarRightButton.configuration?.showsActivityIndicator = false
                        self.switchSaveButton(isSwitch: false)
                        self.failedUpdateName()
                        self.setupAlert(title: "Error", message: "Name not saved! Try again!")
                    }
                case .nul:
                    self.navBarRightButton.configuration?.showsActivityIndicator = false
                    self.switchSaveButton(isSwitch: false)
                    self.setupAlert(title: "Error", message: "Something went wrong! Try again!")
                }
        }
        }
        
        print("navBarRightButtonHandler()")
    }
    
    @objc func navBarLeftButtonHandler() {
        
        if imageIsChanged {
            imageData = nil
            imageUser.image = imageReturn
            imageIsChanged = false
            imageReturn = nil
        }
        navBarLeftButton.isHidden = true
        userNameTextField.text = currentUser?.displayName
        switchEditButton(isSwitch: true)
        userNameTextField.isUserInteractionEnabled = false
        imageUser.isUserInteractionEnabled = false
        isStateEditButton = !isStateEditButton
        print("navBarLeftButtonHandler()")
    }
    
    @objc func didChangeTextFieldNameOrEmail() {
        
        isValidTextField { (isValid) in
            switchSaveButton(isSwitch: isValid)
        }
        print("didChangeTextFieldNameOrEmail()")
    }
    
    @objc func handleTapSingleGesture() {
        setupAlertEditImageAvatar()
        print("handleTapSingleGesture")
    }
    
}

// MARK: - extension Alerts -

private extension NewProfileViewController {

    func setupAlertEditImageAvatar() {

        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.overrideUserInterfaceStyle = .dark

        let camera = UIAlertAction(title: "Camera", style: .default) { action in
            self.chooseImagePicker(source: .camera)
        }

        let gallery = UIAlertAction(title: "Gallery", style: .default) { action in
            self.chooseImagePicker(source: .photoLibrary)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }

        let deleteAvatar = UIAlertAction(title: "Delete Avatar", style: .destructive) { action in
            self.startRemoveAvatarUpdateUI()
            self.managerFB.removeAvatarFromCurrentUser { state in
                switch state {

                case .success:
//                    self.cacheImageRemoveMemoryAndDisk()
                    self.managerFB.cacheImageRemoveMemoryAndDisk(imageView: self.imageUser)
                    self.endRemoveAvatarUpdateUI()
                    self.imageUser.image = UIImage(named: "DefaultImage")
                case .failed:
                    self.failedRemoveAvatarUpdateUI()
                }
            }
        }

        let titleAlertController = NSAttributedString(string: "Add image to avatar", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        alert.setValue(titleAlertController, forKey: "attributedTitle")


        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)

        if let _ = managerFB.avatarRef, imageIsChanged == false {
            alert.addAction(deleteAvatar)
        }
        present(alert, animated: true, completion: nil)

    }


    // Log in again before retrying this request
    func setupAlertRecentLogin(title:String, message:String, placeholder: String, completionHandler: @escaping (String) -> Void ) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { action in
            print("did OK")
            let textField = alertController.textFields?.first
            guard let text = textField?.text else {return}
            completionHandler(text)
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("did cancel")
            // isDelete = false
            self.saveRemuveCartProductFB()
        }

        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        present(alertController, animated: true, completion: nil)
    }


    func wrapperOverDeleteAlert(title:String, message: String) {
        self.setupAlertRecentLogin(title: title, message: message, placeholder: "enter password") { password in

            self.deleteAccountButton.configuration?.showsActivityIndicator = true

            self.managerFB.reauthenticateUser(password: password) { (stateCallback) in

                switch stateCallback {

                case .success:

                    self.managerFB.deleteAccaunt { (state) in
                        switch state {

                        case .success:
                            self.managerFB.removeAvatarFromDeletedUser()
                            self.deleteAccountButton.configuration?.showsActivityIndicator = false
                            self.setupAlert(title: "Success", message: "Current accaunt delete!")
                        case .failed:
                            self.isAnimateDeleteButtonAnonUser = false
                            self.deleteAccountButton.configuration?.showsActivityIndicator = false
                            self.setupFailedAlertDeleteAccount(title: "Failed", message: "Something went wrong. Try again!")
                        case .failedRequiresRecentLogin:
                            self.deleteAccountButton.configuration?.showsActivityIndicator = false
                            self.wrapperOverDeleteAlert(title: "Error", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
                        }
                    }
                case .failed:
                    self.deleteAccountButton.configuration?.showsActivityIndicator = false
                    // тут вызвать вместо setupFailedAlertDeleteAccount -> user.reauthenticate(with: credential)
                    // потому что иначе мы заново будем создавать удаление -> deleteAccaunt { error in } а оно уже вызвано и привело сюда.
                    // или написать [weak self] в setupAlertRecentLogin

                    self.isAnimateDeleteButtonAnonUser = false
                    self.setupFailedAlertDeleteAccount(title: "Failed", message: "Something went wrong. Try again later!")
                case .wrongPassword:
                    self.deleteAccountButton.configuration?.showsActivityIndicator = false
                    self.wrapperOverDeleteAlert(title: "Invalid password", message: "Enter the password for \(self.currentUser?.email ?? "the current account") to delete your account!")
                }
            }
        }
    }


    func setupAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in

        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func setupFailedAlertDeleteAccount(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // save data user remuveProducts
            self.saveRemuveCartProductFB()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }



    func setupDeleteAlert(title: String, message: String, isDeleteCompletion: @escaping (Bool) -> Void) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "DELETE", style: .destructive) { action in
            print(" Did Delete")
            isDeleteCompletion(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("Did Cancel")
            isDeleteCompletion(false)
        }

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            print("Did Delete Accaunt")
        }
    }

}

extension NewProfileViewController: SignInViewControllerDelegate {
    func userIsPermanent() {
        print("$$$$$func userIsPermanent()")
        guard let user = currentUser else {return}
        print(" $$$$$guard let user = currentUser")
        self.userIsPermanentUpdateUI(user)
    }
}

extension NewProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImagePicker(source:UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originImage = info[.editedImage] as? UIImage
        let size = CGSize(width: 400, height: 400)
        // а что если compressedImage придет nil?
        let compressedImage = originImage?.thumbnailOfSize(size)
        imageReturn = imageUser.image
        imageUser.image = compressedImage
        imageUser.contentMode = .scaleAspectFill
        imageUser.clipsToBounds = true
        imageData = compressedImage?.jpegData(compressionQuality: 0.2)
        imageIsChanged = true
        switchSaveButton(isSwitch: true)
        dismiss(animated: true, completion: nil)

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

