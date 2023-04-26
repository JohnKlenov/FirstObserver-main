//
//  EyeButton.swift
//  FirstObserver
//
//  Created by Evgenyi on 11.03.23.
//

import Foundation
import UIKit

final class EyeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupEyeButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func tintColorDidChange() {
//        super.tintColorDidChange()
//        tintColor = R.Colors.label
//    }
    private func setupEyeButton() {
//        if let image = UIImage(named: R.Strings.AuthControllers.SignIn.imageSystemNameEyeSlash) {
//            let tintableImage = image.withRenderingMode(.alwaysTemplate)
//            setImage(tintableImage, for: .normal)
//        }
        setImage(UIImage(systemName: "eye.slash"), for: .normal)
            
        tintColor = R.Colors.label
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        isEnabled = false
    }
}
