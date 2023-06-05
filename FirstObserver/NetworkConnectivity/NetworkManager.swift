//
//  NetworkManager.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.06.23.
//

import UIKit

class AppDelegater: UIView {
    
    func application() {
        NetworkMonitor.shared.startMonitoring()
    }
    
}

class NetworkViewController: UIViewController {
    
   
    override func viewWillAppear(_ animated: Bool) {
//        networkConnected()
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
//         networkConnected()
        print("new commit for networkManager")
     }
    func printing() {
        print("new commit for networkManager")    }
}





























//import Foundation
//import SystemConfiguration
//
//final class NetworkManager {
//
//    static let shared = NetworkManager()
//
//    private var monitor: NWPathMonitor?
//    private var queue = DispatchQueue.global(qos: .background)
//
//    private var isConnected = false
//
//    func startMonitoring() {
//        monitor = NWPathMonitor()
//
//        monitor?.start(queue: queue)
//
//        monitor?.pathUpdateHandler = { [weak self] path in
//            self?.isConnected = path.status == .satisfied
//            print("Is connected: \(self?.isConnected ?? false)")
//        }
//    }
//
//    func stopMonitoring() {
//        monitor?.cancel()
//    }
//}

//import Foundation
//import SystemConfiguration
//
//class NetworkManager {
//    
//    static let shared = NetworkManager()
//    
//    private var reachability: SCNetworkReachability?
//    private var isMonitoring = false
//    
//    var isConnected: Bool {
//        var flags = SCNetworkReachabilityFlags()
//        SCNetworkReachabilityGetFlags(reachability!, &flags)
//        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
//    }
//    
//    func startMonitoring() {
//        guard !isMonitoring else {
//            return
//        }
//        var address = sockaddr()
//        address.sa_len = UInt8(MemoryLayout.size(ofValue: address))
//        address.sa_family = sa_family_t(AF_INET)
//        reachability = withUnsafePointer(to: &address, {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { ptr in
//                SCNetworkReachabilityCreateWithAddress(nil, ptr)
//            }
//        })
//        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
//        SCNetworkReachabilitySetCallback(reachability!, { (_, _, _) in
//            print("SCNetworkReachabilitySetCallback")
//            NotificationCenter.default.post(name: .reachabilityChanged, object: nil)
//        }, &context)
//        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetCurrent(), CFRunLoopMode.commonModes.rawValue)
//        isMonitoring = true
//    }
//    
//    func stopMonitoring() {
//        guard isMonitoring, let reachability = reachability else {
//            return
//        }
//        SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.commonModes.rawValue)
//        isMonitoring = false
//    }
//}
