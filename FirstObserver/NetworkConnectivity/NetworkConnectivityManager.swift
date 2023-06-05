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

enum ConnectionType {
    case wifi
    case cellular
    case ethernet
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    var connectionType: ConnectionType?
    private var hasStatus: Bool = false
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            print("monitor.pathUpdateHandler")
            
            self.getConnectionType(path)
#if targetEnvironment(simulator)
            if (!self.hasStatus) {
                self.isConnected = path.status == .satisfied
                self.hasStatus = true
            } else {
                self.isConnected = !self.isConnected
            }
#else
            self.isConnected = path.status == .satisfied
#endif
            print("isConnected: " + String(self.isConnected))
            
            //            логическое значение, которое возвращает true, если текущее соединение осуществляется через сотовую связь или точку доступа.
            print("path.isExpensive - \(path.isExpensive)")
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
        
    }
    
    func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            self.connectionType = .wifi
            print(".wifi")
        } else if path.usesInterfaceType(.cellular) {
            self.connectionType = .cellular
            print(".cellular")
        } else if path.usesInterfaceType(.wiredEthernet) {
            self.connectionType = .ethernet
            print(".ethernet")
        } else {
            connectionType = nil
            print(".connectionType = nil")
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}














//            if path.status == .unsatisfied {
//                    print("New Disconnected")
//                   }
//                   else if path.status == .requiresConnection {
//                           print("New Searching...")
//
//                   }
//                   else {
//                           print("New Connected")
//                   }

//            guard let monitor = monitor else {return}
//            self.monitor.currentPath.status == .satisfied

//            if path.status != .unsatisfied {
//                self.isConnected = true
//            } else {
//                self.isConnected = false
//            }
            
//            if path.status == .satisfied {
//                self.isConnected = true
//            } else {
//                self.isConnected = false
//            }

//            print("path.status - \(path.status)")

//extension NWInterface.InterfaceType: CaseIterable {
//    public static var allCases: [NWInterface.InterfaceType] = [
//        .other,
//        .wifi,
//        .cellular,
//        .loopback,
//        .wiredEthernet
//    ]
//}


//            if path.status == .unsatisfied {
//
//                DispatchQueue.main.sync(){
//                    print("New Disconnected")
//                }
//                   }
//                   else if path.status == .requiresConnection {
//                       DispatchQueue.main.sync(){
//                           print("New Searching...")
//                       }
//
//                   }
//                   else {
//                       DispatchQueue.main.sync(){
//                           print("New Connected")
//                       }
//
//                   }

//if path.status == .satisfied {
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

//                    let isWifi: Bool = path.usesInterfaceType(.wifi)
//                    let isCellular: Bool = path.usesInterfaceType(.cellular)
//
//                    let iswiredEthernet: Bool = path.usesInterfaceType(.wiredEthernet)
//                    let isloopback: Bool = path.usesInterfaceType(.loopback)
//                    let isother: Bool = path.usesInterfaceType(.other)
        
//            if isWifi {
//                          print("Wi-Fi")
//                      }
//                      else if isCellular {
//                          print("Mobile Data")
//                      }
//                      else if iswiredEthernet {
//                          print("Wired Ethernet")
//                      }
//                      else if isloopback {
//                          print("Loop Back")
//                      }
//                      else if isother {
//                          print("Other")
//                      }

//            if path.status == .unsatisfied {
//                    print("New Disconnected")
//                   }
//                   else if path.status == .requiresConnection {
//                           print("New Searching...")
//
//                   }
//                   else {
//                           print("New Connected")
//                   }
