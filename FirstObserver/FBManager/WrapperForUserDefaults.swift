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

    var isFailedChangePhotoURLUser: Bool {
        get {
            return userDeafaults.bool(forKey: "isFailedChangePhotoURLUser")
        }
        set(newValue) {
            userDeafaults.set(newValue, forKey: "isFailedChangePhotoURLUser")
        }
    }

}


