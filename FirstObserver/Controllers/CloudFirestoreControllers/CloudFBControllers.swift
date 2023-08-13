//
//  CloudFBControllers.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.23.
//

import Foundation
import UIKit
import MapKit


class HomeVC: ParentNetworkViewController {
    
    var pinsMall: [PinMall] = []
    private var pinsMallFB: [PinMallsFB] = [] {
        didSet {
            getPinsMall()
        }
    }
    
    var model = [SectionModelHVC]() {
        didSet {
            if model.count == 3 {
                if isFirstLoadingStatus {
//                    reloadData()
                }
                
            }
        }
    }
    
    var modelDict = [String:SectionModelHVC]() {
        didSet {
            if modelDict.count == 3 {
                let sorted = modelDict.sorted { $0.key < $1.key }
                let valuesArraySorted = Array(sorted.map({ $0.value }))
                model = valuesArraySorted
            }
        }
    }
    
    var checkLoadingStatus: [String:Bool] = [:] {
        didSet {
            
            if checkLoadingStatus.count == 7 {
                let filteredDictionary = checkLoadingStatus.filter { (_, value) in
                    return value == false
                }
                
                if filteredDictionary.isEmpty {
                    // Обработка случая отсутствия элементов со значением false
                    if !isFirstLoadingStatus {
                        tabBarController?.view.isUserInteractionEnabled = true
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                        //                    reloadData()
                        isFirstLoadingStatus = true
                        print("Finished loading data")
                    }
                    
                } else {
                    if !isFirstLoadingStatus {
                        // удаляем те элементы из checkLoadingStatus которые false
                        // stopSpiner
                        // func alertView(forData:filteredDictionary) - Try again! ->
                        // -> reloadingData(forData: filteredDictionary)
                    }
                }
            }
        }
    }
    
    var cartProducts: [ProductItem] = []
    var shops:[String:[Shop]] = [:]
    private var currentGender = ""
    var isFirstLoadingStatus = false
    
    let cloudFB = ManagerFB.shared
    let managerFB = FBManager.shared
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.view.isUserInteractionEnabled = false
        configureActivityView()
        
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
       
        managerFB.userListener { currentUser in
            if currentUser == nil {
                self.cartProducts = []
                self.managerFB.signInAnonymously()
            }
            self.cloudFB.removeListenerFetchCartProducts()
            self.cloudFB.fetchCartProducts { products in
                self.cartProducts = products
                self.cloudFB.cartProducts = products
            }
        }
        
        getGenderData(gender: currentGender)
        
        // а что если сработает наблюдатель при имеющихся данных в shops["Man"]
        // но вернется ошибка и shops = []???
//        cloudFB.fetchShops(gender: "Man") { (shops, error) in
//            if let shops = shops, error == nil {
//                self.shops["Man"] = shops
//                self.checkLoadingStatus["ShopsMan"] = true
//            } else {
//                if !self.isFirstLoadingStatus {
//                    self.checkLoadingStatus["ShopsMan"] = false
//                }
//            }
//        }
//
//        cloudFB.fetchShops(gender: "Woman") { (shops, error) in
//            if let shops = shops {
//                self.shops["Woman"] = shops
//            }
//        }
        
        cloudFB.fetchPinMalls { pins in
            self.pinsMallFB = pins
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
    }
    
//    data methods
    
    func fetchShopsMan() {
        cloudFB.fetchShopsMan { (shops, error) in
            if let shops = shops, error == nil {
                self.shops["Man"] = shops
                self.checkLoadingStatus["ShopsMan"] = true
            } else {
                if !self.isFirstLoadingStatus {
                    self.checkLoadingStatus["ShopsMan"] = false
                }
            }
        }
    }
    
    func fetchShopsWoman() {
        cloudFB.fetchShopsWoman { (shops, error) in
            if let shops = shops, error == nil {
                self.shops["Woman"] = shops
                self.checkLoadingStatus["ShopsWoman"] = true
            } else {
                if !self.isFirstLoadingStatus {
                    self.checkLoadingStatus["ShopsWoman"] = false
                }
            }
        }
    }
    
//    func fetchData
    
    func getPinsMall() {
        self.pinsMall = []
        pinsMallFB.forEach { pin in
            let pinMall = PinMall(title: pin.mall, locationName: pin.address, discipline: "Торговый центр", coordinate: CLLocationCoordinate2D(latitude: pin.latitude ?? 1.0, longitude: pin.longitude ?? 1.0), imageName: pin.refImage)
            self.pinsMall.append(pinMall)
        }
    }
    
    func getGenderData(gender: String) {
        
        cloudFB.fetchPreviewMalls(gender: gender) { malls in
            let section = SectionModelHVC(section: "Malls", items: malls)
            self.modelDict["A"] = section
        }
        
        cloudFB.fetchPreviewShops(gender: gender) { shops in
            let section = SectionModelHVC(section: "Shops", items: shops)
            self.modelDict["B"] = section
        }
        
        cloudFB.fetchPopularProducts(gender: gender) { products in
            let section = SectionModelHVC(section: "PopularProducts", items: products)
            self.modelDict["C"] = section
        }
    }
    
    func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
//            configureActivityView()
            cloudFB.removeListenerFetchPreviewMalls()
            cloudFB.removeListenerFetchPreviewShops()
            cloudFB.removeListenerFetchPopularProducts()
            modelDict = [:]
            currentGender = gender
            getGenderData(gender: currentGender)
        }
    }
    
    func reloadingData(forData: [String : Bool]) {
        
        forData.forEach { item in
            switch item.key {
            case "ShopsMan":
                // removeListenerFetchShopsMan()
                // self.shops["Man"] = nil
                // fetchShopsMan()
                print("")
            case "ShopsWoman":
                // removeListenerFetchShopsWoman()
                // self.shops["Woman"] = nil
                // fetchShopsWoman()
                print("")
            case "PinMalls":
                print("")
            case "PreviewMalls":
                print("")
            case "PreviewShops":
                print("")
            case "PopularProducts":
                print("")
            case "CartProducts":
                print("")
            default:
                print("Returned message for analytic FB Crashlytics error")
            }
        }
    }
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
    //        let currentPin = pinsMall.filter({$0.title == path})
    //                mallVC.path = path
    //                mallVC.currentPin = currentPin
    //            }
    //            self.navigationController?.pushViewController(mallVC, animated: true)
    //        }
    //    }
}

class MallVC: ParentNetworkViewController {
    
    var shops:[Shop] = []
//    var pinsMall: [PinMall] = []
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
    var cartProducts: [ProductItem] = []
    
    let cloudFB = ManagerFB.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudFB.fetchShopProdutcts(gender: currentGender, path: path) { model in
            self.modelShopProducts = model
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCartProdutcs()
    }
    
    func fetchCartProdutcs() {
        guard let tabBarVCs = tabBarController?.viewControllers else { return }
        tabBarVCs.forEach { (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? HomeVC {
                    self.pinsMall = homeVC.pinsMall
                    self.cartProducts = homeVC.cartProducts
                }
            }
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
    
    var isAddedToCard = false {
        didSet {
//            addToCardButton.setNeedsUpdateConfiguration()
        }
    }
    
    let cloudFB = ManagerFB.shared
    
    
    private func saveProductFB(completion: @escaping (StateCallback) -> Void) {
        
        guard let product = modelProduct else {
            // print("Returne message for analitic FB Crashlystics error")
            completion(.failed)
            return
        }
        
        let data: [String: Any] = [
            "brand": product.brand ?? "",
            "model": product.model ?? "",
            "category": product.category ?? "",
            "popularityIndex": product.popularityIndex ?? 0,
            "strengthIndex": product.strengthIndex ?? 0,
            "type": product.type ?? "",
            "description": product.description ?? "",
            "price": product.price ?? 0,
            "refImage": product.refImage ?? [""],
            "shops": product.shops ?? [""],
            "originalContent": product.originalContent ?? [""]
        ]
        
        cloudFB.addProductFB(documentID: product.model ?? "", product: data) { state in
            
            switch state {
                
            case .success:
                //                self.configureBadgeValue()
                completion(.success)
            case .failed:
                completion(.failed)
            }
        }
    }
    
    @objc func addToCardPressed(_ sender: UIButton) {
        
        saveProductFB { state in
            switch state {
            case .success:
//                self.setupAlertView(state: .success, frame: self.view.frame)
                self.isAddedToCard = !self.isAddedToCard
            case .failed:
//                self.setupAlertView(state: .failed, frame: self.view.frame)
                print("")
            }
        }
    }
    
    
    // MARK: - DetailViewController for shop
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinsMall.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        
        let mall = pinsMall[indexPath.row].title ?? ""
        var shopsMall:[Shop] = []
        shops.forEach { shop in
            if let mallShop = shop.mall, mallShop == mall {
                shopsMall.append(shop)
            }
        }
        vc.configureViews(model: shopsMall.first ?? Shop())
        present(vc, animated: true, completion: nil)
    }
}


class CartVC: ParentNetworkViewController {
    
    // тут мы должны иметь все shops потому что в корзине может быть добавлен товар Man and Woman
    var shops:[String:[Shop]] = [:]
}
