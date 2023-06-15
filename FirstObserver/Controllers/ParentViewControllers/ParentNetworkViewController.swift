//
//  ParentNetworkViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 7.06.23.
//

import Foundation
import UIKit

// Created

// NewHomeViewController
// CatalogViewController
// MallsViewController
// CartViewController
// NewProfileViewController
// NewMallViewController
// BrandsViewController
// AllProductViewController
// NewProductViewController
// NewSignInViewController
// NewSignUpViewController
// MapViewController

// Not Created

// FullScreenViewController



class ParentNetworkViewController: UIViewController {
    
    var activityView: ActivityContainerView = {
        let view = ActivityContainerView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var alert: UIAlertController?
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        networkConnected()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
        networkConnected()
    }
    
    func networkConnected() {
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.main.async {
                self.alert?.dismiss(animated: true)
                self.alert = nil
            }
        } else {
            DispatchQueue.main.async {
                self.activityView.isAnimating { [weak self] isAnimatig in
                    if isAnimatig {
                        self?.activityView.stopAnimating()
                        self?.activityView.removeFromSuperview()                }
                }
                self.setupAlertNotConnected()
            }
        }
    }
    
    func configureActivityView() {
        view.addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
        activityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
        activityView.startAnimating()
    }
    
    func setupAlertNotConnected() {
        
        alert = UIAlertController(title: "You're offline!", message: "No internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default) { [weak self] action in
            self?.networkConnected()
        }
        alert?.addAction(okAction)
        if let alert = alert {
            present(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        print("deinit ParentNetworkViewController")
    }
}
