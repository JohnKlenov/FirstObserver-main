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
//        static let activeFirst = UIColor(hexString: "#FBD86D")
//        static let activeSecond = UIColor(hexString: "#8D5FF7")
//        static let activeThird = UIColor(hexString: "#59D7F9")
//        static let inactive = UIColor(hexString: "#929DA5")
//        static let red = UIColor(hexString: "#F8173E")
        
        static let baseBackgroundBlack = UIColor(hexString: "#1C1C1C")
        static let baseBackgroundBlack2 = UIColor(hexString: "#202020")
        static let baseBackgroundWhite = UIColor(hexString: "#F8F4FF")
        
        static let textColorWhite = UIColor(hexString: "#FFFFFF")
        static let textColorLithWhite = UIColor(hexString: "#F8F4FF")
        static let textColorBlack = UIColor(hexString: "#000000")
        static let textColorDarkGray = UIColor(hexString: "#2c2c2c")
        static let textColorLithGray = UIColor(hexString: "#B5B5B5")
        static let textColorLithGray2 = UIColor(hexString: "#838383")
        static let textColorRed = UIColor(hexString: "#F8173E")
        static let textColorActive = UIColor(hexString: "#BA55D3")
        
        static let backgroundViewWhite = UIColor(hexString: "#FFFFFF")
        static let backgroundViewBlack = UIColor(hexString: "#000000")
        static let backgroundViewLithGray = UIColor(hexString: "#B5B5B5")
        static let backgroundViewDarkGray = UIColor(hexString: "#2c2c2c")
        static let backgroundViewRed = UIColor(hexString: "#F8173E")
        
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
            enum SignIn {
                static let placeholderEmailTextField = "Enter email"
                static let placeholderPasswordTextField = "Enter password"
                
                static let emailLabel = "Email"
                static let passwordLabel = "Password"
                static let signInLabel = "Sign In"
                
                static let signUpButton = "Sign Up"
                static let forgotPasswordButton = "Forgot password?"
                static let signInButtonStart = "Sign In"
                static let signInButtonProcess = "Signing In..."
                
                static let imageSystemNameEye = "eye"
                static let imageSystemNameEyeSlash = "eye.slash"
                
            }
            enum SignUP {
                static let nameLabel = "Name"
                static let emailLabel = "Email"
                static let passwordLabel = "Password"
                static let reEnterPasswordLabel = "Re-enter password"
                static let signUpLabel = "Sign Up"
                
                static let placeholderNameTextField = "Enter user name"
                static let placeholderEmailTextField = "Enter email"
                static let placeholderPasswordTextField = "Enter password"
                static let placeholderReEnterTextField = "Enter password"
                
                static let imageSystemNameEye = "eye"
                static let imageSystemNameEyeSlash = "eye.slash"
                
                static let signUpButtonStart = "Sign In"
                static let signUpButtonProcess = "Signing In..."
            }
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

//    enum Fonts {
//        static func helvelticaRegular(with size: CGFloat) -> UIFont {
//            UIFont(name: "Helvetica", size: size) ?? UIFont()
//
//        }
//    }
    
    enum Fonts {
        enum helveltica: String {
            case bold = "Helvetica-Bold"
            case regular = "Helvetica"
            case medium = "Helvetica-BoldOblique"
            
            public func font(size: CGFloat) -> UIFont {
                return UIFont(name: self.rawValue, size: size)!
            }
        }
    }
  
}
