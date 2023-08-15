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
                if isFirstLoading, !isSwitchLoading {
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
    
    var firstLoadingStatus: [String:Bool] = [:] {
        didSet {
            if firstLoadingStatus.count == 7 {
                let filteredDictionary = firstLoadingStatus.filter { (_, value) in
                    return value == false
                }
                
                if filteredDictionary.isEmpty {
                    // Обработка случая отсутствия элементов со значением false
                        tabBarController?.view.isUserInteractionEnabled = true
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                        //                    reloadData()
                        isFirstLoading = true
                        firstLoadingStatus = [:]
                } else {
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                        self.setupAlertReloadFirstData(forData: filteredDictionary)
                }
            }
        }
    }
    
    var switchLoadingStatus: [String:Bool] = [:] {
        didSet {
            if switchLoadingStatus.count == 3 {
                let filteredDictionary = switchLoadingStatus.filter { (_, value) in
                    return value == false
                }
                if filteredDictionary.isEmpty {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    //                    reloadData()
                    isSwitchLoading = false
                    switchLoadingStatus = [:]
                } else {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    self.setupAlertReloadSwitchData(forData: filteredDictionary)
                }
            }
        }
    }
    
    var cartProducts: [ProductItem] = []
    var shops:[String:[Shop]] = [:]
    private var currentGender = ""
    var isFirstLoading = false
    var isSwitchLoading = false
    
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
            self.fetchCartProducts()
        }
        fetchShopsMan()
        fetchShopsWoman()
        fetchPinMalls()
        fetchPreviewMalls(gender: currentGender)
        fetchPreviewShops(gender: currentGender)
        fetchPopularProducts(gender: currentGender)
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
                if !self.isFirstLoading {
                    self.firstLoadingStatus["ShopsMan"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["ShopsMan"] = false
                }
            }
        }
    }
    
    func fetchShopsWoman() {
        cloudFB.fetchShopsWoman { (shops, error) in
            if let shops = shops, error == nil {
                self.shops["Woman"] = shops
                if !self.isFirstLoading {
                    self.firstLoadingStatus["ShopsWoman"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["ShopsWoman"] = false
                }
            }
        }
    }
    
    func fetchPinMalls() {
        cloudFB.fetchPinMalls { (pins, errro) in
            if let pins = pins, errro == nil {
                self.pinsMallFB = pins
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PinMalls"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PinMalls"] = false
                }
            }
        }
    }
    
    func fetchPreviewMalls(gender: String) {
        cloudFB.fetchPreviewMalls(gender: gender) { (malls, error) in
            if let malls = malls, error == nil {
                let section = SectionModelHVC(section: "Malls", items: malls)
                self.modelDict["A"] = section
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PreviewMalls"] = true
                }
                if self.isSwitchLoading {
                    self.switchLoadingStatus["PreviewMalls"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PreviewMalls"] = false
                }
                if self.isSwitchLoading {
                    self.switchLoadingStatus["PreviewMalls"] = false
                }
            }
        }
    }
    
    func fetchPreviewShops(gender: String) {
        cloudFB.fetchPreviewShops(gender: gender) { (shops, error) in
            if let shops = shops, error == nil {
                let section = SectionModelHVC(section: "Shops", items: shops)
                self.modelDict["B"] = section
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PreviewShops"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PreviewShops"] = false
                }
            }
        }
    }
    
    func fetchPopularProducts(gender: String) {
        cloudFB.fetchPopularProducts(gender: gender) { (products, error) in
            if let products = products, error == nil {
                let section = SectionModelHVC(section: "PopularProducts", items: products)
                self.modelDict["C"] = section
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PopularProducts"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["PopularProducts"] = false
                }
            }
        }
    }
    
    func fetchCartProducts() {
        self.cloudFB.fetchCartProducts { (products, error) in
            if let products = products, error == nil {
                self.cartProducts = products
                self.cloudFB.cartProducts = products
                if !self.isFirstLoading {
                    self.firstLoadingStatus["CartProducts"] = true
                }
            } else {
                if !self.isFirstLoading {
                    self.firstLoadingStatus["CartProducts"] = false
                }
            }
        }
    }
    
    func startTimer() {
        
    }
    func getPinsMall() {
        self.pinsMall = []
        pinsMallFB.forEach { pin in
            let pinMall = PinMall(title: pin.mall, locationName: pin.address, discipline: "Торговый центр", coordinate: CLLocationCoordinate2D(latitude: pin.latitude ?? 1.0, longitude: pin.longitude ?? 1.0), imageName: pin.refImage)
            self.pinsMall.append(pinMall)
        }
    }
    
    func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
            configureActivityView()
            cloudFB.removeListenerFetchPreviewMalls()
            cloudFB.removeListenerFetchPreviewShops()
            cloudFB.removeListenerFetchPopularProducts()
            modelDict = [:]
            currentGender = gender
            isSwitchLoading = true
            fetchPreviewMalls(gender: currentGender)
            fetchPreviewShops(gender: currentGender)
            fetchPopularProducts(gender: currentGender)

        }
    }
    
    func reloadingFirstData(forData: [String : Bool]) {
        configureActivityView()
        forData.forEach { item in
            switch item.key {
            case "ShopsMan":
                cloudFB.removeListenerFetchShopsMan()
                firstLoadingStatus["ShopsMan"] = nil
                fetchShopsMan()
            case "ShopsWoman":
                cloudFB.removeListenerFetchShopsWoman()
                firstLoadingStatus["ShopsWoman"] = nil
                fetchShopsWoman()
            case "PinMalls":
                cloudFB.removeListenerFetchPinMalls()
                firstLoadingStatus["PinMalls"] = nil
                fetchPinMalls()
            case "PreviewMalls":
                cloudFB.removeListenerFetchPreviewMalls()
                firstLoadingStatus["PreviewMalls"] = nil
                fetchPreviewMalls(gender: currentGender)
            case "PreviewShops":
                cloudFB.removeListenerFetchPreviewShops()
                firstLoadingStatus["PreviewShops"] = nil
                fetchPreviewShops(gender: currentGender)
            case "PopularProducts":
                cloudFB.removeListenerFetchPopularProducts()
                firstLoadingStatus["PopularProducts"] = nil
                fetchPopularProducts(gender: currentGender)
            case "CartProducts":
                cloudFB.removeListenerFetchCartProducts()
                firstLoadingStatus["CartProducts"] = nil
                fetchCartProducts()
            default:
                print("Returned message for analytic FB Crashlytics error")
            }
        }
    }
    
    func reloadingSwitchData(forData: [String : Bool]) {
        configureActivityView()
        forData.forEach { item in
            switch item.key {
                
            case "PreviewMalls":
                cloudFB.removeListenerFetchPreviewMalls()
                switchLoadingStatus["PreviewMalls"] = nil
                fetchPreviewMalls(gender: currentGender)
            case "PreviewShops":
                cloudFB.removeListenerFetchPreviewShops()
                switchLoadingStatus["PreviewShops"] = nil
                fetchPreviewShops(gender: currentGender)
            case "PopularProducts":
                cloudFB.removeListenerFetchPopularProducts()
                switchLoadingStatus["PopularProducts"] = nil
                fetchPopularProducts(gender: currentGender)
            default:
                print("Returned message for analytic FB Crashlytics error")
            }
        }
    }
    
    func setupAlertReloadFirstData(forData: [String : Bool]) {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .cancel) {[weak self] _ in
            self?.reloadingFirstData(forData: forData)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setupAlertReloadSwitchData(forData: [String : Bool]) {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .cancel) {[weak self] _ in
            self?.reloadingSwitchData(forData: forData)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
        
        cloudFB.fetchPreviewMalls(gender: gender) { (malls, error) in
            
            if let malls = malls, error == nil {
                var mallsItem: [PreviewSection] = []
                malls.forEach { item in
                    if let mall = item.malls {
                        mallsItem.append(mall)
                    }
                }
                self.mallsModel = mallsItem
            } else {
                // alert??? Try agayne?
            }
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









//            self.cloudFB.fetchCartProducts { (products, error) in
//                if let products = products, error == nil {
//                    self.cartProducts = products
//                    self.cloudFB.cartProducts = products
//                    if !self.isFirstLoading {
//                        self.firstLoadingStatus["CartProducts"] = true
//                    }
//                } else {
//                    if !self.isFirstLoading {
//                        self.firstLoadingStatus["CartProducts"] = false
//                    }
//                }
//            }

//    func getGenderData(gender: String) {
        
//        cloudFB.fetchPreviewMalls(gender: gender) { malls in
//            let section = SectionModelHVC(section: "Malls", items: malls)
//            self.modelDict["A"] = section
//        }
        
//        cloudFB.fetchPreviewShops(gender: gender) { shops in
//            let section = SectionModelHVC(section: "Shops", items: shops)
//            self.modelDict["B"] = section
//        }
        
//        cloudFB.fetchPopularProducts(gender: gender) { products in
//            let section = SectionModelHVC(section: "PopularProducts", items: products)
//            self.modelDict["C"] = section
//        }
//    }

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
