//
//  NetworkConnectivityManager.swift
//  FirstObserver
//
//  Created by Evgenyi on 31.05.23.
//

import Foundation
import Network

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

    private(set) var isConnected = false
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
//            print("startMonitoring")
//            self?.isConnected = path.status != .unsatisfied
//            print("startMonitoring isConnected - \(String(describing: self?.isConnected))")
//            self?.isExpensive = path.isExpensive
//            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
//            print("self?.currentConnectionType - \(String(describing: self?.currentConnectionType))")
            sleep(1)
//                    if path.status == .satisfied {
//                        DispatchQueue.main.sync(){
//                            print("satisfied")
//                        }
//                    } else if path.status == .requiresConnection {
//                        DispatchQueue.main.sync(){
//                            print("requiresConnection требуетПодключение")
//                        }
//                    } else  {
//                        DispatchQueue.main.sync(){
//                            print("Not Satisfied")
//                        }
//                    }
//            let networkStatus = networkPath.status
                    
                    let isWifi: Bool = path.usesInterfaceType(.wifi)
                    let isCellular: Bool = path.usesInterfaceType(.cellular)
                    
                    let iswiredEthernet: Bool = path.usesInterfaceType(.wiredEthernet)
                    let isloopback: Bool = path.usesInterfaceType(.loopback)
                    let isother: Bool = path.usesInterfaceType(.other)
           
            if path.status == .unsatisfied {
               
                DispatchQueue.main.sync(){
                    print("New Disconnected")
                }
                   }
                   else if path.status == .requiresConnection {
                       DispatchQueue.main.sync(){
                           print("New Searching...")
                       }
                       
                   }
                   else {
                       DispatchQueue.main.sync(){
                           print("New Connected")
                       }
                       
                   }
            if isWifi {
                          print("Wi-Fi")
                      }
                      else if isCellular {
                          print("Mobile Data")
                      }
                      else if iswiredEthernet {
                          print("Wired Ethernet")
                      }
                      else if isloopback {
                          print("Loop Back")
                      }
                      else if isother {
                          print("Other")
                      }
//            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)

    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

