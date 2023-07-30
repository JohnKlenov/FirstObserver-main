//
//  UpdateJSON.swift
//  FirstObserver
//
//  Created by Evgenyi on 26.07.23.
//

import Foundation
import UIKit


struct Products: Codable {

    //    let brand: String
    let model: String
    let description: String
    let price: String
    let url: [String]
    let malls: [String]
}

struct Category: Codable {
    var category: String
    var products: [Products]
}

struct Brands: Codable {
    var brand: String
    var category: [Category]
}


struct Garderob: Codable {
    var groups: [Brands]
}

class UpdateJson {
    
    func getModel(callBack: ([Brands]) -> Void) {
        var garderob: [Brands] = []
        let url = Bundle.main.url(forResource: "BrandsMan", withExtension: "json")!
        do {
            print("url - \(url)")
            let data = try Data(contentsOf: url)
            let json = try JSONDecoder().decode(Garderob.self, from: data)
            garderob = json.groups
        } catch {
            print("func getModel(callBack error - \(error)")
        }
        callBack(garderob)
    }
}
