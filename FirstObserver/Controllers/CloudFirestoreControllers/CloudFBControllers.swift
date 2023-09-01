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
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    reloadData()
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
                    reloadData()
                } else {
                    // views.isHidden = true
                    // viewStub.isHidden = false
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
                    reloadData()
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
    var emergencyCurrentGender: String?
    let cloudFB = ManagerFB.shared
    let managerFB = FBManager.shared
    let defaults = UserDefaults.standard
    
    var timer: Timer?
    
    let allShops: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapAllShops(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure view and view hierarchy where viewStub.isHidden = true
        
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
        
        if let _ = emergencyCurrentGender {
            emergencyReloadData()
        } else {
            switchGender()
        }
        
    }
    
    @objc func didTapAllShops(_ sender: UIButton) {
        
        let allShopsVC = AllShopsVC()
        
        if let emergencyCurrentGender = emergencyCurrentGender {
            allShopsVC.currentGender = emergencyCurrentGender
        } else {
            allShopsVC.currentGender = currentGender
        }
        
        let productSection = model.filter({$0.section == "Shops"})
        
        if let previewShops = productSection.first?.items {
            allShopsVC.modelPreviewShops = previewShops
        }
        
        self.navigationController?.pushViewController(allShopsVC, animated: true)
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
    
    func emergencyReloadData() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        configureActivityView()
        startSwitchGenderTimer()
        cloudFB.removeListenerFetchPreviewMalls()
        cloudFB.removeListenerFetchPreviewShops()
        cloudFB.removeListenerFetchPopularProducts()
        isBlockingModel = true
        isBlockingFirstLoading = true
        isBlockingSwitchGenderLoading = false
        switchLoadingStatus = [:]
        modelDict = [:]
        currentGender = gender
        fetchPreviewMalls(gender: currentGender)
        fetchPreviewShops(gender: currentGender)
        fetchPopularProducts(gender: currentGender)
    }
    
    func reloadingFirstData(forData: [String : Bool]) {
        isBlockingFirstLoading = false
        configureActivityView()
        startFirstTimer()
        
        deleteStatusDataFirstLoading(forData: forData) {
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
    
    func deleteStatusDataFirstLoading(forData: [String : Bool], completion: () -> Void) {
        
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
    
    func deleteStatusDataSwitch(forData: [String : Bool], completion: () -> Void) {
        
        var counter = 0
        forData.forEach { item in
            counter += 1
            switch item.key {
           
            case "PreviewMalls":
                cloudFB.removeListenerFetchPreviewMalls()
                switchLoadingStatus["PreviewMalls"] = nil
            case "PreviewShops":
                cloudFB.removeListenerFetchPreviewShops()
                switchLoadingStatus["PreviewShops"] = nil
            case "PopularProducts":
                cloudFB.removeListenerFetchPopularProducts()
                switchLoadingStatus["PopularProducts"] = nil
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
        
        deleteStatusDataSwitch(forData: forData) {
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
    
    // когда крутится спинер мы не должны иметь возможность взаимодействовать с UI
    func setupAlertReloadSwitchData(forData: [String : Bool]) {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .cancel) {[weak self] _ in
            self?.reloadingSwitchData(forData: forData)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.switchLoadingStatus = [:]
            self.modelDict = [:]
            
            if self.emergencyCurrentGender == nil {
                switch self.currentGender {
                case "Man":
                    self.emergencyCurrentGender = "Woman"
                case "Woman":
                    self.emergencyCurrentGender = "Man"
                default:
                    self.emergencyCurrentGender = "Woman"
                    print("Returned message for analytic FB Crashlytics error")
                }
            }
            print("Did tap Cancel for AlertReloadSwitchData")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func createUniqueMallArray(from shops: [Shop]) -> [String] {
        
        var mallSet = Set<String>()
        for shop in shops {
            mallSet.insert(shop.mall ?? "")
        }
        let uniqueMallArray = Array(mallSet)
        
        return uniqueMallArray
    }
    
    func reloadData() {
        
        // views.isHidden = false
        // viewStub.isHidden = true
        // emergencyCurrentGender = nil
        // implemintation reloadData
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            let mallVC = MallVC()
            let mallSection = model.filter({$0.section == "Malls"})
            let nameMall = mallSection.first?.items[indexPath.row].mall?.name ?? ""
            mallVC.path = nameMall
            mallVC.title = nameMall
            
            if let emergencyCurrentGender = emergencyCurrentGender {
                mallVC.currentGender = emergencyCurrentGender
                mallVC.shops = shops[emergencyCurrentGender] ?? []
            } else {
                mallVC.currentGender = currentGender
                mallVC.shops = shops[currentGender] ?? []
            }
            
            let currentPin = pinsMall.filter({$0.title == nameMall})
            mallVC.currentPin = currentPin
            self.navigationController?.pushViewController(mallVC, animated: true)
            
        case 1:
            let shopProductVC = ShopProdutctsVC()
            let productSection = model.filter({$0.section == "Shops"})
            let path = productSection.first?.items[indexPath.row].shop?.name ?? ""
            shopProductVC.path = path
            shopProductVC.title = path
            
            if let emergencyCurrentGender = emergencyCurrentGender {
                shopProductVC.currentGender = emergencyCurrentGender
                shopProductVC.shops = shops[emergencyCurrentGender] ?? []
            } else {
                shopProductVC.currentGender = currentGender
                shopProductVC.shops = shops[currentGender] ?? []
            }

            self.navigationController?.pushViewController(shopProductVC, animated: true)
            
        case 2:
            let productVC = ProductVC()
            let productSection = model.filter({$0.section == "PopularProducts"})
            let shopsProduct = productSection.first?.items[indexPath.row].popularProduct?.shops ?? []
            
            if let emergencyCurrentGender = emergencyCurrentGender {
            
                var shopsList: [Shop] = []

                shops[emergencyCurrentGender]?.forEach { shop in
                    if shopsProduct.contains(shop.name ?? "") {
                        shopsList.append(shop)
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
            } else {

                var shopsList: [Shop] = []

                shops[currentGender]?.forEach { shop in
                    if shopsProduct.contains(shop.name ?? "") {
                        shopsList.append(shop)
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
            }

            productVC.modelProduct = productSection.first?.items[indexPath.row].popularProduct
            
            cartProducts.forEach { (addedProduct) in
                if addedProduct.model == productSection.first?.items[indexPath.row].popularProduct?.model {
                    productVC.isAddedToCard = true
                }
            }
            self.navigationController?.pushViewController(productVC, animated: true)
            
        default:
            print("Returned message for analytic FB Crashlytics error")
        }
    }
}

extension HomeVC: HeaderMallsViewDelegate {
    func didSelectSegmentControl() {
        
        if let _ = emergencyCurrentGender {
            emergencyReloadData()
        } else {
            switchGender()
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
                    if let mall = item.mall {
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
    var timer: Timer?
    
    var mallModel: [SectionModelHVC] = [] {
        didSet {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
//            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMall()
        // перенести все методы из viewDidLoad в configureViews(mallModel: mallModel)?
        //        mapView.arrayPin = currentPin
        // another methods
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func fetchMall() {
        startTimer()
        configureActivityView()
        cloudFB.fetchMall(gender: currentGender, path: path) { (mallModel, error) in
            if let _ = mallModel, error == nil {
                self.timer?.invalidate()
                self.cloudFB.removeListenerFetchMall()
//                self.configureViews(mallModel: mallModel)
                
            } else {
                self.cloudFB.removeListenerFetchMall()
                self.timer?.invalidate()
                self.activityView.stopAnimating()
                self.activityView.removeFromSuperview()
                // configure viewStub maby ceate method into superClass
                self.setupAlertReloadData()
            }
        }
    }

    private func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            self.cloudFB.removeListenerFetchMall()
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
            self.setupAlertReloadData()
        }
    }
    
    private func setupAlertReloadData() {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .default) { [weak self] _ in
            self?.fetchMall()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Для возврата на предыдущий экран в стеке навигации
            self.navigationController?.popViewController(animated: true)

        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
    //            mallModel = [mallSection, shopSection]
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
    //            let shopProductVC = UIStoryboard.vcById("ShopProdutctVC") as! ShopProdutctsVC
    //            let path = section[indexPath.section].items[indexPath.row].shops?.name ?? ""
//                shopProductVC.path = path
//                shopProductVC.currentGender = currentGender
//                shopProductVC.title = path
//                shopProductVC.shops = shops
//                self.navigationController?.pushViewController(brandVC, animated: true)
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
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            //            collectionView.reloadData()
        }
    }
    var cartProducts: [ProductItem] = []
    
    let cloudFB = ManagerFB.shared
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShopProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataHVC()
    }
    
    private func fetchShopProducts() {
        startTimer()
        configureActivityView()
        cloudFB.fetchShopProdutcts(gender: currentGender, query: path) { (shopProducts, error) in
            if let shopProducts = shopProducts, error == nil {
                self.timer?.invalidate()
                self.cloudFB.removeListenerFetchShopProducts()
                self.modelShopProducts = shopProducts
            } else {
                self.cloudFB.removeListenerFetchShopProducts()
                self.timer?.invalidate()
                self.activityView.stopAnimating()
                self.activityView.removeFromSuperview()
                self.setupAlertReloadData()
            }
        }
    }
    
    private func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            self.cloudFB.removeListenerFetchShopProducts()
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
            self.setupAlertReloadData()
        }
    }
    
    func fetchDataHVC() {
        guard let tabBarVCs = tabBarController?.viewControllers else { return }
        tabBarVCs.forEach { (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? HomeVC {
                    self.pinsMall = homeVC.pinsMall
                    self.cartProducts = homeVC.cartProducts
                    self.shops = homeVC.shops[currentGender] ?? []
                }
            }
        }
    }
    
    private func setupAlertReloadData() {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .default) { [weak self] _ in
            self?.fetchShopProducts()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Для возврата на предыдущий экран в стеке навигации
            self.navigationController?.popViewController(animated: true)

        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
        
        cartProducts.forEach { (addedProduct) in
            if addedProduct.model == modelShopProducts[indexPath.row].model {
                productVC.isAddedToCard = true
            }
        }
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
        // может имеет смысл ставить таймер если операция сохранения будет долгой без ответа?
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

class AllShopsVC: ParentNetworkViewController {
    
    var currentGender = ""
    var modelPreviewShops: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let shopProductVC = ShopProdutctsVC()
        let path = modelPreviewShops[indexPath.row].shop?.name ?? ""
        shopProductVC.path = path
        shopProductVC.currentGender = currentGender
        shopProductVC.title = path
        self.navigationController?.pushViewController(shopProductVC, animated: true)
    }
    
}

// views implemintation from BrandsViewController
class CatalogVC: ParentNetworkViewController {
    
//    @IBOutlet weak var categorysCollectionView: UICollectionView!
//    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var indexCategoryCollectionView = 0
    var selectedCategory:CategoryProducts?
    
    var modelCatalog: CatalogProducts? {
        didSet {
            if let modelCatalog = modelCatalog, !modelCatalog.categorys.isEmpty {
                selectedCategory = modelCatalog.categorys[indexCategoryCollectionView]
            }
            activityView.stopAnimating()
            activityView.removeFromSuperview()
//            categorysCollectionView.reloadData()
//            productsCollectionView.reloadData()
        }
    }
    
    let defaults = UserDefaults.standard
    let cloudFB = ManagerFB.shared
    var timer: Timer?
    var isTroubleFetchData = false
    
    private var currentGender = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentGender()
        fetchProducts(gender: currentGender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDataHVC()
        
        if !isTroubleFetchData {
            switchGender()
        } else {
            getCurrentGender()
            fetchProducts(gender: currentGender)
        }
    }
    
    
    
    private func getCurrentGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        currentGender = gender
    }
    
    private func fetchProducts(gender: String) {
        disableActiveButtons(isSwitch: false)
        startTimer()
        configureActivityView()
        
        cloudFB.fetchProducts(gender: gender) { (modelCatalog, error) in
            
            if let modelCatalog = modelCatalog, error == nil {
                self.timer?.invalidate()
                self.disableActiveButtons(isSwitch: true)
                self.isTroubleFetchData = false
                self.modelCatalog = modelCatalog
            } else {
                self.cloudFB.removeListenerFetchProducts()
                self.timer?.invalidate()
                self.activityView.stopAnimating()
                self.activityView.removeFromSuperview()
                self.setupAlertReloadData()
            }
        }
    }
    
    
    private func disableActiveButtons(isSwitch: Bool) {
        // tabBarController?.view.isUserInteractionEnabled = false
        // sigmentControll.isUserInteractionEnabled = false
    }
    
    func switchGender() {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        if currentGender != gender {
            currentGender = gender
            cloudFB.removeListenerFetchProducts()
            fetchProducts(gender: currentGender)
        }
    }
    
    private func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            self.cloudFB.removeListenerFetchProducts()
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
            self.setupAlertReloadData()
        }
    }
    
    func fetchDataHVC() {
        guard let tabBarVCs = tabBarController?.viewControllers else { return }
        tabBarVCs.forEach { (vc) in
            if let nc = vc as? UINavigationController {
                if let homeVC = nc.viewControllers.first as? HomeVC {
//                    self.pinsMall = homeVC.pinsMall
//                    self.cartProducts = homeVC.cartProducts
//                    self.shops = homeVC.shops[currentGender] ?? []
                }
            }
        }
    }
    
    private func setupAlertReloadData() {
        let alert = UIAlertController(title: "Error ", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .default) { [weak self] _ in
            
            if let currentGender = self?.currentGender {
                self?.fetchProducts(gender: currentGender)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
           
            // Помечаем что данные не были получены
            self.isTroubleFetchData = true
            // tabBarController?.view.isUserInteractionEnabled = true
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func createUniqueMallArray(from shops: [Shop]) -> [String] {
        
        var mallSet = Set<String>()
        for shop in shops {
            mallSet.insert(shop.mall ?? "")
        }
        let uniqueMallArray = Array(mallSet)
        
        return uniqueMallArray
    }
    
}

class CartVC: ParentNetworkViewController {
    
    // тут мы должны иметь все shops потому что в корзине может быть добавлен товар Man and Woman
    var shops:[String:[Shop]] = [:]
}

class PlaceholderView: UIView {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = R.Colors.label
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Дополнительные настройки вашего кастомного view
        backgroundColor = R.Colors.systemBackground
        configureImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        
        // есть несколько стилей прорисовок для символов системных иконок: .thin, .medium ..
        let symbolConfig = UIImage.SymbolConfiguration(weight: .ultraLight)

            let image = UIImage(systemName: "wifi.slash", withConfiguration: symbolConfig)
            let tintableImage = image?.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
            addSubview(imageView)
            setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: centerXAnchor), imageView.centerYAnchor.constraint(equalTo: centerYAnchor), imageView.widthAnchor.constraint(equalTo: widthAnchor), imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)])
    }
    
}


class PlaceholderNavigationController: UINavigationController {
    
    private var placeholderView: PlaceholderView?
    lazy var activityView: ActivityContainerView = {
        let view = ActivityContainerView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlaceholderView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    

    
    // MARK: PlaceholderView -
    
    
    func configurePlaceholderView() {
        
        // Создайте и настройте placeholder view
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        placeholderView = PlaceholderView(frame:frame)
        
        // Добавьте placeholder view на главное представление навигационного контроллера
        if let placeholderView = placeholderView {
            view.addSubview(placeholderView)
            // Перемещает указанное подпредставление так, чтобы оно отображалось позади своих одноуровневых элементов.
            view.sendSubviewToBack(placeholderView)
            // Перемещает указанное подпредставление так, чтобы оно отображалось поверх своих одноуровневых элементов.
//            view.bringSubviewToFront(placeholderView)
        }
        hidePlaceholder()
    }

    func showPlaceholder() {
        // Показать placeholder view и скрыть содержимое контроллера
        topViewController?.view.isHidden = true
        placeholderView?.isHidden = false
    }

    func hidePlaceholder() {
        // Скрыть placeholder view и показать содержимое контроллера
        topViewController?.view.isHidden = false
        placeholderView?.isHidden = true
    }
    
    
    // MARK: ActivityIndicatorView -
    
    func setupSpinnerForPlaceholder() {
        
        if let placeholderView = placeholderView {
            
            placeholderView.addSubview(activityView)
            activityView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor).isActive = true
            activityView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor).isActive = true
            activityView.heightAnchor.constraint(equalTo: placeholderView.widthAnchor, multiplier: 1/4).isActive = true
            activityView.widthAnchor.constraint(equalTo: placeholderView.widthAnchor, multiplier: 1/4).isActive = true
        }
    }
    
    func startSpinnerForPlaceholder() {
        setupSpinnerForPlaceholder()
        activityView.startAnimating()
    }
    
    func stopSpinnerForPlaceholder() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    func setupSpinnerForView() {
        
        if let view = topViewController?.view {
            print("topViewController?.view")
            view.addSubview(activityView)
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            activityView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
            activityView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
        }
    }
    
    func startSpinnerForView() {
        setupSpinnerForView()
        activityView.startAnimating()
    }
    
    func stopSpinnerForView() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
}

//        NotificationCenter.default.removeObserver(self)
// temporary property
//    var alert: UIAlertController?
//        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
//        networkConnected()

//    @objc func showOfflineDeviceUI(notification: Notification) {
//        networkConnected()
//    }
    
//    func networkConnected() {
//        if NetworkMonitor.shared.isConnected {
//            DispatchQueue.main.async {
//                self.alert?.dismiss(animated: true)
//                self.alert = nil
//            }
//        } else {
//            DispatchQueue.main.async {
//                self.activityView.isAnimating { [weak self] isAnimatig in
//                    if isAnimatig {
//                        self?.activityView.stopAnimating()
//                        self?.activityView.removeFromSuperview()                }
//                }
//                self.setupAlertNotConnected()
//            }
//        }
//    }
    
//    func setupAlertNotConnected() {
//
//        alert = UIAlertController(title: "You're offline!", message: "No internet connection", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Try again", style: .default) { [weak self] action in
//            self?.networkConnected()
//        }
//        alert?.addAction(okAction)
//        if let alert = alert {
//            present(alert, animated: true, completion: nil)
//        }
//    }



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
