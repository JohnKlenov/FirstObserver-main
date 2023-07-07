//
//  WrapperForUserDefaults.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.07.23.
//

import Foundation

final class CollectorFailedMethods {

    static let shared = CollectorFailedMethods()
    let userDeafaults = UserDefaults.standard

    // func removeAvatarFromCurrentUser for ProfileVC
    var isFailedChangePhotoURLUser: Bool {
        get {
            return userDeafaults.bool(forKey: "isFailedChangePhotoURLUser")
        }
        set(newValue) {
            userDeafaults.set(newValue, forKey: "isFailedChangePhotoURLUser")
        }
    }
    
    // func signIn
    var isFailedDeleteIsAnonymousUser: Bool {
        get {
            return userDeafaults.bool(forKey: "isFailedDeleteIsAnonymousUser")
        }
        set(newValue) {
            userDeafaults.set(newValue, forKey: "isFailedDeleteIsAnonymousUser")
        }
    }
    
    // func saveDeletedFromCart for signIn
    var isFailedSaveDeletedFromCart: Bool {
        get {
            return userDeafaults.bool(forKey: "isFailedSaveDeletedFromCart")
        }
        set(newValue) {
            userDeafaults.set(newValue, forKey: "isFailedSaveDeletedFromCart")
        }
    }
    
    // func registerUserSignUpVC FBManager
//    var isFailedSaveNameForLinkUserAnon: String? {
//        get {
//            return userDeafaults.string(forKey: "isFailedSaveNameForLinkUserAnon")
//        }
//        set(newValue) {
//            userDeafaults.set(newValue, forKey: "isFailedSaveNameForLinkUserAnon")
//        }
//    }
}


