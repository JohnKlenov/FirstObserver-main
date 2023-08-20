//
//  CloudFBControllers.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.23.
//

import Foundation
import UIKit
import MapKit


// ParentNetworkViewController - использование может быть пересмотрено для Cloud Firestore
// Возможно есть смысл делать проверку на networkConnected() во viewDidLoad при первом запуске.
// if isConnect - запускаем весь код который сейчас лежит во viewDidLoad else Alert
// Alert - Try agayne! и снова вызываем метод networkConnected()
class HomeVC: ParentNetworkViewController {
    
    let allState = ["ShopsMan":false, "ShopsWoman":false, "PinMalls":false, "PreviewMalls":false, "PreviewShops":false, "PopularProducts":false, "CartProducts":false]
    let switchState = ["PreviewMalls":false, "PreviewShops":false, "PopularProducts":false]
    var pinsMall: [PinMall] = []
    private var pinsMallFB: [PinMallsFB] = [] {
        didSet {
            getPinsMall()
        }
    }
    
    var model = [SectionModelHVC]() {
        didSet {
            if model.count == 3 {
                if isBlockingFirstLoading, isBlockingSwitchGenderLoading, isBlockingModel {
//                    activityView.stopAnimating()
//                    activityView.removeFromSuperview()
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
            if firstLoadingStatus.count == allState.count {
               
                    timer?.invalidate()
                
                let filteredDictionary = firstLoadingStatus.filter { (_, value) in
                    return value == false
                }
                
                if filteredDictionary.isEmpty {
                    // Обработка случая отсутствия элементов со значением false
                    tabBarController?.view.isUserInteractionEnabled = true
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    isBlockingFirstLoading = true
                    isBlockingModel = true
                    firstLoadingStatus = [:]
                    //                    reloadData()
                } else {
                    isBlockingFirstLoading = true
                    isBlockingModel = false
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
                
                timer?.invalidate()
               
                let filteredDictionary = switchLoadingStatus.filter { (_, value) in
                    return value == false
                }
                if filteredDictionary.isEmpty {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    isBlockingSwitchGenderLoading = true
                    isBlockingModel = true
                    switchLoadingStatus = [:]
                    //                    reloadData()
                } else {
                    isBlockingSwitchGenderLoading = true
                    isBlockingModel = false
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
    var isBlockingFirstLoading = false
    var isBlockingSwitchGenderLoading = true
    var isBlockingModel = true
    
    let cloudFB = ManagerFB.shared
    let managerFB = FBManager.shared
    let defaults = UserDefaults.standard
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.view.isUserInteractionEnabled = false
        startFirstTimer()
        configureActivityView()
        
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
       
        // если networkNotConnect и мы уже заходили то user лежит в кэши
        // пока networkNotConnect блок не выполнится
        managerFB.userListener { currentUser in
            if currentUser == nil {
                self.cartProducts = []
                self.cloudFB.signInAnonymously()
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
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["ShopsMan"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["ShopsMan"] = false
                }
            }
        }
    }
    
    func fetchShopsWoman() {
        cloudFB.fetchShopsWoman { (shops, error) in
            if let shops = shops, error == nil {
                self.shops["Woman"] = shops
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["ShopsWoman"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["ShopsWoman"] = false
                }
            }
        }
    }
    
    func fetchPinMalls() {
        cloudFB.fetchPinMalls { (pins, errro) in
            if let pins = pins, errro == nil {
                self.pinsMallFB = pins
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PinMalls"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
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
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PreviewMalls"] = true
                }
                if !self.isBlockingSwitchGenderLoading {
                    self.switchLoadingStatus["PreviewMalls"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PreviewMalls"] = false
                }
                if !self.isBlockingSwitchGenderLoading {
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
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PreviewShops"] = true
                }
                if !self.isBlockingSwitchGenderLoading {
                    self.switchLoadingStatus["PreviewShops"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PreviewShops"] = false
                }
                if !self.isBlockingSwitchGenderLoading {
                    self.switchLoadingStatus["PreviewShops"] = false
                }
            }
        }
    }
    
    func fetchPopularProducts(gender: String) {
        cloudFB.fetchPopularProducts(gender: gender) { (products, error) in
            if let products = products, error == nil {
                let section = SectionModelHVC(section: "PopularProducts", items: products)
                self.modelDict["C"] = section
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PopularProducts"] = true
                }
                if !self.isBlockingSwitchGenderLoading {
                    self.switchLoadingStatus["PopularProducts"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["PopularProducts"] = false
                }
                if !self.isBlockingSwitchGenderLoading {
                    self.switchLoadingStatus["PopularProducts"] = false
                }
            }
        }
    }
    
    func fetchCartProducts() {
        self.cloudFB.fetchCartProducts { (products, error) in
            if let products = products, error == nil {
                self.cartProducts = products
                self.cloudFB.cartProducts = products
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["CartProducts"] = true
                }
            } else {
                if !self.isBlockingFirstLoading {
                    self.firstLoadingStatus["CartProducts"] = false
                }
            }
        }
    }
    
    func startFirstTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 12, repeats: false) { _ in
            self.isBlockingFirstLoading = true
            self.isBlockingModel = false
            let reloadDictionary = self.calculateDifference(allState: self.allState, currentState: self.firstLoadingStatus)
            self.firstLoadingStatus = reloadDictionary
        }
    }
    
    func startSwitchGenderTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 12, repeats: false) { _ in
            self.isBlockingSwitchGenderLoading = true
            self.isBlockingModel = false
            let reloadDictionary = self.calculateDifference(allState: self.switchState, currentState: self.switchLoadingStatus)
            self.switchLoadingStatus = reloadDictionary
        }
    }
    
    func calculateDifference(allState: [String: Bool], currentState: [String: Bool]) -> [String: Bool] {
        
        guard currentState.count > 0 else {
            return allState
        }
        var newDictionary:[String: Bool] = [:]

        for (key, _ ) in allState {
            guard let currentValue = currentState[key] else {
                newDictionary[key] = false
                continue
            }
            if currentValue != true {
                newDictionary[key] = false
            } else {
                newDictionary[key] = true
            }
        }
        return newDictionary
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
            startSwitchGenderTimer()
            cloudFB.removeListenerFetchPreviewMalls()
            cloudFB.removeListenerFetchPreviewShops()
            cloudFB.removeListenerFetchPopularProducts()
            modelDict = [:]
            currentGender = gender
            isBlockingSwitchGenderLoading = false
            fetchPreviewMalls(gender: currentGender)
            fetchPreviewShops(gender: currentGender)
            fetchPopularProducts(gender: currentGender)
        }
    }
    
    func reloadingFirstData(forData: [String : Bool]) {
        isBlockingFirstLoading = false
        configureActivityView()
        startFirstTimer()
        
        deleteStatusData(forData: forData) {
            forData.forEach { item in
                
                switch item.key {
                case "ShopsMan":
                    fetchShopsMan()
                case "ShopsWoman":
                    fetchShopsWoman()
                case "PinMalls":
                    fetchPinMalls()
                case "PreviewMalls":
                    fetchPreviewMalls(gender: currentGender)
                case "PreviewShops":
                    fetchPreviewShops(gender: currentGender)
                case "PopularProducts":
                    fetchPopularProducts(gender: currentGender)
                case "CartProducts":
                    fetchCartProducts()
                default:
                    print("Returned message for analytic FB Crashlytics error")
                }
            }
        }
    }
    
    func deleteStatusData(forData: [String : Bool], completion: () -> Void) {
        
        var counter = 0
        forData.forEach { item in
            counter += 1
            switch item.key {
            case "ShopsMan":
                cloudFB.removeListenerFetchShopsMan()
                firstLoadingStatus["ShopsMan"] = nil
            case "ShopsWoman":
                cloudFB.removeListenerFetchShopsWoman()
                firstLoadingStatus["ShopsWoman"] = nil
            case "PinMalls":
                cloudFB.removeListenerFetchPinMalls()
                firstLoadingStatus["PinMalls"] = nil
            case "PreviewMalls":
                cloudFB.removeListenerFetchPreviewMalls()
                firstLoadingStatus["PreviewMalls"] = nil
            case "PreviewShops":
                cloudFB.removeListenerFetchPreviewShops()
                firstLoadingStatus["PreviewShops"] = nil
            case "PopularProducts":
                cloudFB.removeListenerFetchPopularProducts()
                firstLoadingStatus["PopularProducts"] = nil
            case "CartProducts":
                cloudFB.removeListenerFetchCartProducts()
                firstLoadingStatus["CartProducts"] = nil
            default:
                print("Returned message for analytic FB Crashlytics error")
            }
            if counter == forData.count {
                completion()
            }
        }
    }
    
    func reloadingSwitchData(forData: [String : Bool]) {
        isBlockingSwitchGenderLoading = false
        configureActivityView()
        startSwitchGenderTimer()
        
        deleteStatusData(forData: forData) {
            forData.forEach { item in
                switch item.key {
                case "PreviewMalls":
                    fetchPreviewMalls(gender: currentGender)
                case "PreviewShops":
                    fetchPreviewShops(gender: currentGender)
                case "PopularProducts":
                    fetchPopularProducts(gender: currentGender)
                default:
                    print("Returned message for analytic FB Crashlytics error")
                }
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            print("case 0")
//            let mallVC = UIStoryboard.vcById("MallVC") as! MallVC
//            let mallSection = model.filter({$0.section == "Malls"})
//            let nameMall = mallSection.first?.items[indexPath.row].malls?.name ?? ""
//            mallVC.path = nameMall
//            mallVC.title = nameMall
//            mallVC.currentGender = currentGender
//
//            if let shops = shops[currentGender] {
//                mallVC.shops = shops
//            }
//
//            let currentPin = pinsMall.filter({$0.title == nameMall})
//                    mallVC.currentPin = currentPin
//                }
//            self.navigationController?.pushViewController(mallVC, animated: true)
        case 1:
            print("case 1")
            // при Cloud Firestore мы будем в NC переходить на VC с вертикальной прокруткой collectionView и cell как у popularProduct
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let brandVC = storyboard.instantiateViewController(withIdentifier: "BrandsViewController") as! BrandsViewController
//            let brandsSection = modelHomeViewController.filter({$0.section == "Brands"})
//            let refBrand = brandsSection.first?.items[indexPath.row].brands?.brand ?? ""
//            let fullPath = "Brands" + currentGender + "/" + refBrand
//            brandVC.pathRefBrandVC = refBrand
//            brandVC.title = refBrand
//            brandVC.arrayPin = placesMap
//            self.navigationController?.pushViewController(brandVC, animated: true)
        case 2:
            print("case 2")
//            let productVC = NewProductViewController()
//            let productSection = modelHomeViewController.filter({$0.section == "PopularProducts"})
//            let malls = productSection.first?.items[indexPath.row].popularProduct?.malls ?? [""]
//
//            var placesArray:[Places] = []
//            placesMap.forEach { (places) in
//                if malls.contains(places.title ?? "") {
//                    placesArray.append(places)
//                }
//            }
//
//            cartProducts.forEach { (addedProduct) in
//                if addedProduct.model == productSection.first?.items[indexPath.row].popularProduct?.model {
//                    productVC.isAddedToCard = true
//                }
//            }
//            productVC.arrayPin = placesArray
//            productVC.productModel = productSection.first?.items[indexPath.row].popularProduct
//            self.navigationController?.pushViewController(productVC, animated: true)
            
            
            
            
            // альтернатива (product не содержит поле malls только magazines)
            
            //            let productMagazines = productSection.first?.items[indexPath.row].popularProduct?.magazines ?? [""]
            
            //            var magazinesArray:[Shop] = []
            //            shops["currentGender"].forEach { (magazine) in
            //                if productMagazines.contains(mazazine.name ?? "") {
            //                    magazinesArray.append(magazine)
            //                }
            //            }
            
//            let arrayMall = createUniqueMallArray(from: magazinesArray)

            //            var placesArray:[Places] = []
            //            placesMap.forEach { (places) in
            //                if arrayMall.contains(places.title ?? "") {
            //                    placesArray.append(places)
            //                }
            //            }
            
            //            productVC.magazinesArray = magazinesArray
            //            productVC.arrayPin = placesArray
            //            productVC.productModel = productSection.first?.items[indexPath.row].popularProduct
            //            self.navigationController?.pushViewController(productVC, animated: true)
            
//            func createUniqueMallArray(from magazines: [Magazine]) -> [String] {
//                // Создаем временный Set для хранения уникальных значений
//                var mallSet = Set<String>()
//
//                // Итерируемся по массиву magazines и добавляем поля "mall" во множество
//                for magazine in magazines {
//                    mallSet.insert(magazine.mall)
//                }
//
//                // Преобразуем Set обратно в массив
//                let uniqueMallArray = Array(mallSet)
//
//                return uniqueMallArray
//            }

            
        default:
            print("default \(indexPath.section)")
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
                if let _ = nc.viewControllers.first as? NewHomeViewController {
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
//                mallVC.shops = self.shops[self.currentGender]
//                mallVC.currentGender = self.scurrentGender
    //            if let path = mallsModel[indexPath.item].brand {
//            let currentPin = pinsMall.filter({$0.title == path})
//                    mallVC.path = path
//                    mallVC.currentPin = currentPin
//                }
    //            self.navigationController?.pushViewController(mallVC, animated: true)
    //        }
    //    }
}

class MallVC: ParentNetworkViewController {
    
    var shops:[Shop] = []
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
