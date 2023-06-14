//
//  ParentNetworkViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 7.06.23.
//

import Foundation
import UIKit

class ParentNetworkViewController: UIViewController {
    
    var activityView: ActivityContainerView = {
        let view = ActivityContainerView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        print("ParentNetworkViewController  override func viewWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        networkConnected()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        print("ParentNetworkViewController override func viewWillDisappear")
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
        networkConnected()
        print("func showOfflineDeviceUI(notification: Notification)")
    }
    
    func networkConnected() {
        if NetworkMonitor.shared.isConnected {
            print("NetworkManager Connected")
        } else {
            DispatchQueue.main.async {
                self.activityView.isAnimating { [weak self] isAnimatig in
                    if isAnimatig {
                        self?.activityView.stopAnimating()
                        self?.activityView.removeFromSuperview()                }
                }
                self.setupAlertNotConnected()
                print("NetworkManager Not connected")
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
        
        let alert = UIAlertController(title: "You're offline!", message: "No internet connection", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default) { action in
            self.networkConnected()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
