//
//  CloudFBControllers.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.23.
//

import Foundation
import UIKit


class HomeVC: UIViewController {
    
    
    
}

class MallsVC: ParentNetworkViewController {
    
    var pinsMall: [PinMall] = []
    var mallsModel: [PreviewSection] = [] {
        didSet {
//            collectionView.reloadData()
            activityView.stopAnimating()
            activityView.removeFromSuperview()
        }
    }
    var shops:[String:[Shop]] = [:]
    
    let cloudFB = ManagerFB.shared
    let defaults = UserDefaults.standard
    private var currentGender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
        configureActivityView()
        getDataFB(gender: currentGender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
        getDataHVC()
    }
    
    private func getDataFB(gender: String) {
        
        cloudFB.fetchPreviewMalls(gender: gender) { malls in
        var mallsItem: [PreviewSection] = []
            malls.forEach { item in
                if let mall = item.malls {
                    mallsItem.append(mall)
                }
            }
            self.mallsModel = mallsItem
        }
    }
    
    private func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
            configureActivityView()
            cloudFB.removeListenerFetchPreviewMalls()
            currentGender = gender
            getDataFB(gender: currentGender)
        }
    }
    
    private func getDataHVC() {
        
        guard let tabBarVCs = tabBarController?.viewControllers else {return}
        for vc in tabBarVCs {
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? NewHomeViewController {
//                    homeVC.cartProducts
//                    self.pinsMall = homeVC.pinsMall
//                    self.shops = homeVC.shops
                }
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let mallVC = UIStoryboard.vcById("MallVC") as? MallVC
//        if let mallVC = mallVC {
//            mallVC.pinsMall = self.pinsMall
//            mallVC.shops = self.shops[self.currentGender]
//            mallVC.currentGender = self.scurrentGender
//            if let path = mallsModel[indexPath.item].brand {
//                mallVC.path = path
//            }
//            self.navigationController?.pushViewController(mallVC, animated: true)
//        }
//    }
}

class MallVC: ParentNetworkViewController {
    
    var shops:[Shop] = []
    var pinsMall: [PinMall] = []
    var currentPin:[PinMall] = []
    var path: String = ""
    var currentGender = ""
    
    let cloudFB = ManagerFB.shared
    
    var mallModel: [SectionModelHVC] = [] {
        didSet {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
//            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityView()
        cloudFB.fetchMall(gender: currentGender, path: path) { mallModel in
//            self.configureViews(mallModel: mallModel)
        }
//        currentPin = pinsMall.filter({$0.title == path})
//        mapView.arrayPin = currentPin
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //    private func configureViews(mallModel:MallModel)  {
    //
    //        var shopSection = SectionModelHVC(section: "Shops", items: [])
    //            shops.forEach { (shop) in
    //                if shop.mall == self.path {
    //                    let itemSection = PreviewSection(name: shop.mall, refImage: shop.logo, floor: shop.floor)
    //                    let item = Item(malls: nil, shops: itemSection, popularProduct: nil)
    // В Cell будем доставть let firstRef = model.brands?.floor
    //                    shopSection.items.append(item)
    //                }
    //            }
    
    //
    //        var mallSection = SectionModelHVC(section: "Mall", items: [])
    //        mallModel.refImage.forEach { ref in
    //    let itemSection = PreviewSection(name: nil, refImage: ref, floor: nil)
    //                    let item = Item(malls: itemSection, shops: nil, popularProduct: nil)
    // В Cell будем доставть let firstRef = model.brands?.refImage
    //            mallSection.items.append(item)
    //        }
    //
    //        self.title = mallModel.name
    //
    //        if let plan = mallModel.floorPlan {
    //            floorPlanMall = plan
    //        } else {
    //            floorPlanButton.isHidden = true
    //        }
    //
    //        if let web = mallModel.webSite {
    //            webSite = web
    //        } else {
    //            websiteMallButton.isHidden = true
    //        }
    //
    //        if brandSection.items.count == mallModel.brands.count && mallSection.items.count == mallModel.refImage.count {
    //            section = [mallSection, shopSection]
    //        }
    //    }
    
    //    private func reloadData() {
    //
    //        var snapshot = NSDiffableDataSourceSnapshot<SectionModelHVC, Item>()
    //        snapshot.appendSections(section)
    //
    //        for item in section {
    //            snapshot.appendItems(item.items, toSection: item)
    //        }
    //        dataSource?.apply(snapshot)
    //    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    //        switch indexPath.section {
    //        case 0:
    //            print("DidTap Mall Section")
    //        case 1:
    //            // при Cloud Firestore мы будем в NC переходить на VC с вертикальной прокруткой collectionView и cell как у popularProduct
    //            let shopProductVC = UIStoryboard.vcById("ShopProdutctVC") as! ShopProdutctVC
    //            let path = section[indexPath.section].items[indexPath.row].shops?.name ?? ""
    //            shopProductVC.path = path
    //            shopProductVC.currentGender = currentGender
    //            shopProductVC.title = path
    //            shopProductVC.shops = shops
    //            shopProductVC.pinsMall = pinsMall
    //            self.navigationController?.pushViewController(brandVC, animated: true)
    //        default:
    //            print("DidTap Default Section")
    //        }
    //    }
    
}

class ShopProdutctsVC: ParentNetworkViewController {
    
    var shops:[Shop] = []
    var pinsMall: [PinMall] = []
    var path: String = ""
    var currentGender = ""
    var modelShopProducts: [ProductItem] = [] {
        didSet {
            //            collectionView.reloadData()
        }
    }
    
    let cloudFB = ManagerFB.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudFB.fetchShopProdutcts(gender: currentGender, path: path) { model in
            self.modelShopProducts = model
        }
    }
    
    func createUniqueMallArray(from shops: [Shop]) -> [String] {
        
        var mallSet = Set<String>()
        for shop in shops {
            mallSet.insert(shop.mall ?? "")
        }
        let uniqueMallArray = Array(mallSet)
        
        return uniqueMallArray
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productVC = ProductVC()
        
        var shopsList: [Shop] = []
        
        if let shopsProduct = modelShopProducts[indexPath.row].shops {
            shops.forEach { shop in
                if shopsProduct.contains(shop.name ?? "") {
                    shopsList.append(shop)
                }
            }
        }
        
        let mallList = createUniqueMallArray(from: shopsList)
        
        var pinList: [PinMall] = []
        
        pinsMall.forEach { pin in
            if mallList.contains(pin.title ?? "") {
                pinList.append(pin)
            }
        }
        
        productVC.pinsMall = pinList
        productVC.shops = shopsList
        productVC.modelProduct = modelShopProducts[indexPath.row]
        
    }
}

class ProductVC: ParentNetworkViewController {
    
    var shops:[Shop] = []
    var pinsMall: [PinMall] = []
    var modelProduct: ProductItem?
}
