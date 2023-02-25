//
//  TestModelProductVC.swift
//  FirstObserver
//
//  Created by Evgenyi on 25.02.23.
//

import UIKit

class ModelForProductVC {
    
    static var shared = ModelForProductVC()
    
    let p1 = Product(name: "Nike AIR FORCE White", price: 350, image: UIImage(named: "p1")!)
    let p2 = Product(name: "Nike x Carhartt WIP AIR FORCE", price: 280, image: UIImage(named: "p2")!)
    let p3 = Product(name: "Nike AIR TAILWIND 79", price: 455, image: UIImage(named: "p3")!)
    let p4 = Product(name: "Nike AIR FOAMPOSITE ONE", price: 677, image: UIImage(named: "p4")!)
    let p5 = Product(name: "Nike AIR FORCE 1 FOAMPOSITE CUP", price: 410, image: UIImage(named: "p5")!)
    let p6 = Product(name: "Nike LF1 DUCKBOOT 17", price: 473, image: UIImage(named: "p6")!)
    let p7 = Product(name: "Nike LF1 DUCKBOOT 17 Metallic", price: 355, image: UIImage(named: "p7")!)
    let p8 = Product(name: "Nike TIEMPO VETTA 17 Gold", price: 856, image: UIImage(named: "p8")!)
    
    var nike: [Product] = []
    
    func imagesProduct() -> [Product] {
        
        nike = [p1,p2,p3,p4,p5,p6,p7,p8]
        
        return nike
    }
}
