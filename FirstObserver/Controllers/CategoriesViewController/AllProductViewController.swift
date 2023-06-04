//
//  allProductViewController.swift
//  FirstObserver
//
//  Created by Evgenyi on 4.09.22.
//

import UIKit

// мы можем обойтись без этого VC а использовать BrandsViewController во всех вариантах
class AllProductViewController: BrandsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let searchCategory = pathRefAllPRoductVC {
            managerFB.getCategoryForBrands(path: computerPathBrandVC, searchCategory: searchCategory) { garderob in
                self.productsForCategory = garderob
            }
        }
    }
    
    // neede override methode super class and call hes root method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        managerFB.removeObserverCategoryProduct(path: computerPathBrandVC)
    }
    
    deinit {
        print("deinit deinit deinit AllProductViewController ")
    }
    
}
