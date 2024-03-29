//
//  AuthTextField.swift
//  FirstObserver
//
//  Created by Evgenyi on 10.03.23.
//

import Foundation
import UIKit

final class AuthTextField: UITextField {
    
    var textPadding = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: -5,
            right: 0
        )
    
    init(placeholder:String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    // Init?(coder: NSCoder) - имеет отношение к storyboard.
    //    @available(*, unavailable) - Но так как у нас его нет мы сделаем пометку что бы компилятор его не использовал.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField(placeholder: String) {
//        UIColor.lightGray
        backgroundColor = .clear
        textColor = R.Colors.label
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : R.Colors.placeholderText])
        font = .systemFont(ofSize: 15, weight: .medium)
        borderStyle = .none
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
}

