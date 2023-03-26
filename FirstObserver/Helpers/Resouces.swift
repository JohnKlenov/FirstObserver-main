//
//  Resouces.swift
//  FirstObserver
//
//  Created by Evgenyi on 26.03.23.
//

import UIKit

// должен лежать в UITabBarController
enum Tabs: Int, CaseIterable {
    case overview
    case session
    case progress
    case settings
}

enum R {
    
    // MARK: - Colors -
    enum Colors {
        static let activeFirst = UIColor(hexString: "#FBD86D")
        static let activeSecond = UIColor(hexString: "#8D5FF7")
        static let activeThird = UIColor(hexString: "#59D7F9")
//        static let inactive = UIColor(hexString: "#929DA5")

        static let red = UIColor(hexString: "#F8173E")
        
        static let backgroundBlack = UIColor(hexString: "#1C1C1C")
        static let backgroundBlack2 = UIColor(hexString: "#202020")
        static let backgroundWhite = UIColor(hexString: "#F8F4FF")
        
        static let tintColorWhite = UIColor(hexString: "#FFFFFF")
        static let tintColorBlack = UIColor(hexString: "#000000")
        static let tintColorLithGray = UIColor(hexString: "#B5B5B5")
        static let tintColorLithGray2 = UIColor(hexString: "#838383")
        static let tintColorRed = UIColor(hexString: "#F8173E")
        static let tintColorActive = UIColor(hexString: "#BA55D3")
        
        static let backgroundButtonBlack = UIColor(hexString: "#131313")
    }

    
    // MARK: - String  -
    enum Strings {
        enum TabBarItem {
//            static func title(for tab: Tabs) -> String {
//                switch tab {
//                case .overview: return "Overview"
//                case .session: return "Session"
//                case .progress: return "Progress"
//                case .settings: return "Settings"
//                }
//            }
        }

        enum NavBar {
            static let profile = "Profile"
        }
        
        enum TabBarController {
            enum Home {}
            enum Catalog {}
            enum Malls {}
            enum Cart {}
            
            enum Profile {
                enum Views {
                    static let navBarButtonEdit = "Edit"
                    static let navBarButtonSave = "Save"
                    static let navBarButtonCancel = "Cancel"
                    
                    static let signInUpButton = "SignIn/SignUp"
                    static let signOutButton = "Sign Out"
                    static let deleteButton = "Delete Account"
                    
                    static let anonymousNameTextField = "User is anonymous"
                    static let placeholderNameTextField = "Enter you name"
                }
                enum Alert {}
            }
        }
        
        enum AuthControllers {
            enum SignIn {}
            enum SignUP {}
        }
        
        enum OtherControllers {
            enum Product {}
            enum BrandProducts {}
            enum CategoryProducts {}
            enum Mall {}
            enum Map {}
            enum FullScreen {}
            enum Onboard {}
        }
    }

    
    // MARK: - Image -
    enum Images {
        enum TabBar {
//            static func icon(for tab: Tabs) -> UIImage? {
//                switch tab {
//                case .overview: return UIImage(named: "overview_tab")
//                case .session: return UIImage(named: "session_tab")
//                case .progress: return UIImage(named: "progress_tab")
//                case .settings: return UIImage(named: "settings_tab")
//                }
//            }
        }

        enum Profile {
            static let defaultAvatarImage = UIImage(named: "DefaultImage")
        }
        
        enum DefaultImage {
            static let forAllProducts = UIImage(named: "DefaultImage")
        }
    }

    enum Fonts {
        static func helvelticaRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
            
        }
    }
}

