//
//  UIView + extension.swift
//  FirstObserver
//
//  Created by Evgenyi on 6.01.23.
//

import Foundation
import UIKit


extension UIView {
    
    func addBottomBorder(with color: UIColor, height: CGFloat) {
            let separator = UIView()
            separator.backgroundColor = color
            separator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            separator.frame = CGRect(x: 0,
                                     y: frame.height - height,
                                     width: frame.width,
                                     height: height)
            addSubview(separator)
        }
    
    func addTopBorder(with color: UIColor, height: CGFloat) {
            let separator = UIView()
            separator.backgroundColor = color
            separator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            separator.frame = CGRect(x: 0,
                                     y: height,
                                     width: frame.width,
                                     height: height)
            addSubview(separator)
        }
    
    // System button отрабатывают миганием при нажатии а custom button нужно руками это делать.
    func makeSystem(_ button:UIButton) {
        
        button.addTarget(self, action: #selector(handleIn), for: [.touchDown, .touchDragInside])
        button.addTarget(self, action: #selector(handleOut), for: [.touchDragOutside, .touchUpInside, .touchUpOutside, .touchDragExit, .touchCancel])
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) {
            self.alpha = 0.55
        }
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
}
