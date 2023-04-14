//
//  MallSection.swift
//  FirstObserver
//
//  Created by Evgenyi on 22.02.23.
//

import Foundation
import UIKit

struct MallSection: Decodable, Hashable {
    let section: String
    let items: [MImage]
}

extension MallSection {
    
    static func getData() -> [MallSection] {
        
        let mallsImage1 = MImage(image: "ic_food_banner1")
        let mallsImage2 = MImage(image: "ic_food_banner2")
        let mallsImage3 = MImage(image: "ic_food_banner3")
        let mallsImage4 = MImage(image: "ic_food_banner4")
        
        let mallsSection = MallSection(section: "Mall", items: [mallsImage1, mallsImage2, mallsImage3, mallsImage4])
        
        let categoryImage1 = MImage(image: "ic_bestseller")
        let categoryImage2 = MImage(image: "ic_express")
        let categoryImage3 = MImage(image: "ic_food_seleted")
        let categoryImage4 = MImage(image: "ic_newlaunch")
        let categoryImage5 = MImage(image: "ic_pocket")
        let categoryImage6 = MImage(image: "ic_premium")
        
        let categorySection = MallSection(section: "Brands", items: [categoryImage1, categoryImage2, categoryImage3, categoryImage4, categoryImage5, categoryImage6])
        return [mallsSection, categorySection]
    }
}

struct MImage: Decodable, Hashable {
    let image: String
    var brand = "Nike"
    var model = "Air Mode"
    var mall = "ТЦ Gallery"
    var price = "1200 BYN"
}
