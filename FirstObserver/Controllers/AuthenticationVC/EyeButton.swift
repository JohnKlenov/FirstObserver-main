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
    
    private func setupEyeButton() {
        setImage(UIImage(systemName: "eye.slash"), for: .normal)
        tintColor = R.Colors.label
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        isEnabled = false
    }
}
