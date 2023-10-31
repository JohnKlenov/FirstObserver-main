//
//  ModelLayerMyProject.swift
//  FirstObserver
//
//  Created by Evgenyi on 27.10.23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import MapKit




// MARK: - Application Model -

// Models

enum NetworkError: Error {
    case failInternetError
    case noInternetConnection
}

struct ItemNew: Hashable {
    let mall: PreviewSectionNew?
    let shop: PreviewSectionNew?
    let popularProduct: ProductItemNew?
//    let mallImage: String?
}

struct PreviewSectionNew: Hashable {
    let name: String?
    let refImage: String?
    let floor: Int?
    let priorityIndex:Int?
    init(dict: [String: Any]) {
        name = dict["name"] as? String
        refImage = dict["refImage"] as? String
        floor = dict["refImage"] as? Int
        priorityIndex = dict["priorityIndex"] as? Int
    }
}

struct SectionModelNew: Hashable {
    let section: String
    var items: [ItemNew]
}


struct ShopNew {
    var name:String?
    var mall:String?
    var floor:String?
    var refImage:String?
    var telefon:String?
    var webSite:String?
    init(dict: [String: Any]) {
        name = dict["name"] as? String
        mall = dict["mall"] as? String
        floor = dict["refImage"] as? String
        refImage = dict["refImage"] as? String
        telefon = dict["telefon"] as? String
        webSite = dict["webSite"] as? String
    }
}

struct ProductItemNew: Hashable {
    let brand: String?
    let model: String?
    let category: String?
    let priorityIndex: Int?
    let strengthIndex: Int?
    let season: String?
    let color: String?
    let material: String?
    let description: String?
    let price: Int?
    let refImage: [String]?
    let shops: [String]?
    let originalContent: String?
    let gender: String?
    init(dict: [String: Any]) {
        brand = dict["brand"] as? String
        model = dict["model"] as? String
        category = dict["category"] as? String
        priorityIndex = dict["priorityIndex"] as? Int
        strengthIndex = dict["strengthIndex"] as? Int
        season = dict["season"] as? String
        color = dict["color"] as? String
        material = dict["material"] as? String
        description = dict["description"] as? String
        price = dict["price"] as? Int
        refImage = dict["refImage"] as? [String]
        shops = dict["shops"] as? [String]
        originalContent = dict["originalContent"] as? String
        gender = dict["gender"] as? String
    }
}

struct PinNew {
    
    let mall:String?
    let refImage:String?
    let address:String?
    let objectType:String?
    let latitude:Double?
    let longitude:Double?
    init(dict: [String: Any]) {
        mall = dict["mall"] as? String
        refImage = dict["refImage"] as? String
        address = dict["address"] as? String
        objectType = dict["objectType"] as? String
        latitude = dict["latitude"] as? Double
        longitude = dict["longitude"] as? Double
    }
}

class PinMapNew: NSObject, MKAnnotation {

    let title: String?
    let locationName: String?
    let discipline: String?
    let imageName: String?
    let coordinate: CLLocationCoordinate2D

    init(title:String?, locationName:String?, discipline:String?, coordinate: CLLocationCoordinate2D, imageName: String?) {

        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.imageName = imageName
        super.init()
    }

    var subtitle: String? {
        return locationName
    }

}

class BunchData {
    var model:[String:SectionModelNew]?
//    var shops:[String:[ShopNew]]?
//    var cartProducts: [ProductItemNew]?
//    var pinMall: [PinNew]?
}




final class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    private var listeners: [String:ListenerRegistration] = [:]
    
    var currentUserID:String?
    var currentCartProducts:[ProductItemNew]?
    var shops:[String:[ShopNew]]?
    var pinMall: [PinNew]?
   
    
    var currentGender:String = {
        return UserDefaults.standard.string(forKey: "gender") ?? "Woman"
    }()
    
    
    // MARK: - UserDefaults
    
    func setGender(gender:String) {
        UserDefaults.standard.set(gender, forKey: "gender")
    }
    
    
    // MARK: - CloudFirestore
    // если cartProducts пуст то как это может быть nil???
    func fetchStartCollection(for path: String, completion: @escaping (Any?, Error?) -> Void) {
        let collection = db.collection(path)
        let quary = collection.order(by: "priorityIndex", descending: false)
        
        let listener = quary.addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                completion(nil, error)
                print("Returned message for analytic FB Crashlytics error")
                return
            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            var documents = [[String : Any]]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                documents.append(documentData)
            }
            completion(documents, nil)
        }
        listeners[path] = listener
    }
    
    func fetchCartProducts(completion: @escaping ([ProductItemNew]?) -> Void) {
        
        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
        
        fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items)
            } catch {
                //                ManagerFB.shared.CrashlyticsMethod
                completion(nil)
            }
            
        }
    }
    
    func removeListenerForCardProducts() {
        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
        removeListeners(for: path)
    }
    
    func removeListeners(for path: String) {
        listeners.filter { $0.key == path }
        .forEach { $0.value.remove() }
    }
    
    
    // MARK: - Auth
    
    
    func userListener(currentUser: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
//            self.currentUser = user
            currentUser(user)
        }
    }
    
    func signInAnonymously() {
        
        Auth.auth().signInAnonymously { (authResult, error) in
            
            guard error == nil, let authResult = authResult else {
                print("Returne message for analitic FB Crashlystics")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.signInAnonymously()
                }
                return
            }
            self.addEmptyCartProducts(uid: authResult.user.uid)
        }
    }
    
    func addEmptyCartProducts(uid: String) {
        
        let usersCollection = Firestore.firestore().collection("usersAccount")
        let userDocument = usersCollection.document(uid)
        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
            if error != nil {
                print("Returne message for analitic FB Crashlystics")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.addEmptyCartProducts(uid: uid)
                }
            }
        }
    }
    
    func listenForUserID(completion: @escaping (String) -> Void) {
        userListener { currentUser in
            guard let currentUser = currentUser else {
                self.currentCartProducts = nil
                self.signInAnonymously()
                return
            }
            completion(currentUser.uid)
        }
    }
    
}



// MARK: - Screens -



// MARK: - HomeVC


// Протокол для модели данных
protocol HomeModelInput: AnyObject {
    func fetchGenderData()
    func fetchDataSource(completion: @escaping ([String:SectionModelNew]?) -> Void)
    func firstFetchData()
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
}

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
//    func didFetchData(data: Any)
}

enum StateDataSource {
    case firstStart
    case fetchGender
}

// Controller

class AbstractHomeViewController: PlaceholderNavigationController {
    
    private var homeModel: HomeModelInput?
    
    var stateDataSource: StateDataSource = .firstStart
    var homeDataSource:[String : SectionModelNew] = [:] {
        didSet {
            
        }
    }
    
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeModel = HomeFirebaseService(output: self)
        navController?.startSpinner()
        
        homeModel?.fetchDataSource(completion: { homeDataSource in
            guard let homeDataSource = homeDataSource else {
                self.navController?.stopSpinner()
                if self.stateDataSource == .firstStart {
                    self.navController?.showPlaceholder()
                }
                self.alertFetchFirstData()
                return
            }
            self.stateDataSource = .fetchGender
            self.homeDataSource = homeDataSource
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
    }
    
    func switchGender() {
        homeModel?.isSwitchGender(completion: {
            self.homeModel?.fetchGenderData()
        })
    }
    
    func repeatedFetchData() {
        switch stateDataSource {
        case .firstStart:
            homeModel?.firstFetchData()
        case .fetchGender:
            homeModel?.fetchGenderData()
        }
    }
    
}

extension AbstractHomeViewController {
   
    func alertFetchFirstData() {
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try agayn", style: .cancel) { _ in
            self.repeatedFetchData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension AbstractHomeViewController:HomeModelOutput {
   
}

extension AbstractHomeViewController:HeaderSegmentedControlViewDelegate {
    func didSelectSegmentControl(gender: String) {
        homeModel?.setGender(gender: gender)
        switchGender()
    }
}

// view

protocol HeaderSegmentedControlViewDelegate: AnyObject {
    func didSelectSegmentControl(gender:String)
}

class HeaderSegmentedControlView: UICollectionReusableView {
    weak var delegate: HeaderSegmentedControlViewDelegate?
    
    func configureCell(title: String, gender:String) {
        //        segmentedControl.selectedSegmentIndex = gender == "Woman" ? 0 : 1
        //        label.text = title
    }
    
    @objc func didTapSegmentedControl(_ segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            delegate?.didSelectSegmentControl(gender: "Woman")
        case 1:
            delegate?.didSelectSegmentControl(gender: "Man")
        default:
            break
        }
    }

}


// Model

class HomeFirebaseService {
    
    weak var output: HomeModelOutput?
    
    let serviceFB = FirebaseService.shared
    let group = DispatchGroup()
    var timer: Timer?
    var pathsGenderListener = [String]()
    var pathsTotalListener = [String]()
    var bunchData:BunchData?
    
    var gender:String = ""
    
    
    let previewService = PreviewCloudFirestoreService()
    let productService = ProductCloudFirestoreService()
    let shopsService = ShopsCloudFirestoreService()
    let pinService = PinCloudFirestoreService()
    
    init(output: HomeModelOutput) {
        self.output = output
        gender = serviceFB.currentGender
    }
    
    func createItem(malls: [PreviewSectionNew]? = nil, shops: [PreviewSectionNew]? = nil, products: [ProductItemNew]? = nil) -> [ItemNew] {
        
        var items = [ItemNew]()
        if let malls = malls {
            items = malls.map {ItemNew(mall: $0, shop: nil, popularProduct: nil)}
        } else if let shops = shops {
            items = shops.map {ItemNew(mall: nil, shop: $0, popularProduct: nil)}
        } else if let products = products {
            items = products.map {ItemNew(mall: nil, shop: nil, popularProduct: $0)}
        }
        return items
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            
            self.pathsGenderListener.forEach { path in
                self.bunchData = nil
                self.group.leave()
                self.serviceFB.removeListeners(for: path)
            }
            
            self.pathsTotalListener.forEach { path in
                self.group.leave()
                self.serviceFB.removeListeners(for: path)
            }
        }
    }
    
    func removeGenderListeners() {
        pathsGenderListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
}

extension HomeFirebaseService: HomeModelInput {
    
    func setGender(gender: String) {
        serviceFB.setGender(gender: gender)
    }
    
    
    func isSwitchGender(completion: @escaping () -> Void) {
        if gender != serviceFB.currentGender {
            gender = serviceFB.currentGender
            completion()
        }
    }
    
    func firstFetchData() {
        fetchGenderData()
        fetchTotalData()
    }
    
   
    func fetchDataSource(completion: @escaping ([String : SectionModelNew]?) -> Void) {
        listenerCartProducts()
        firstFetchData()
        group.notify(queue: .main) {
            completion(self.bunchData?.model)
            self.timer?.invalidate()
        }
    }
    
    func fetchGenderData() {
        
        pathsTotalListener = []
        bunchData = BunchData()
        removeGenderListeners()
        pathsGenderListener = []
        
        startTimer()
        
        group.enter()
        pathsGenderListener.append("previewMalls\(gender)")
        previewService.fetchPreviewSection(path: "previewMalls\(gender)") { malls in
            guard let malls = malls else {
                return
            }
            
            let items = self.createItem(malls: malls, shops: nil, products: nil)
            let mallSection = SectionModelNew(section: "Malls", items: items)
            
            guard let _ = self.bunchData?.model?["A"] else {
                self.group.enter()
                self.bunchData?.model?["A"] = mallSection
                self.group.leave()
                return
            }
            
            self.bunchData?.model?["A"] = mallSection
            self.group.leave()
        }
        
        group.enter()
        pathsGenderListener.append("previewShops\(gender)")
        previewService.fetchPreviewSection(path: "previewShops\(gender)") { shops in
            
            guard let shops = shops else {
                return
            }
            
            let items = self.createItem(malls: nil, shops: shops, products: nil)
            let shopSection = SectionModelNew(section: "Shops", items: items)
            
            guard let _ = self.bunchData?.model?["B"] else {
                self.group.enter()
                self.bunchData?.model?["B"] = shopSection
                self.group.leave()
                return
            }
            
            self.bunchData?.model?["B"] = shopSection
            self.group.leave()
        }
        
        group.enter()
        pathsGenderListener.append("popularProducts\(gender)")
        productService.fetchProducts(path: "popularProducts\(gender)") { products in
            guard let products = products else {
                return
            }
            
            let items = self.createItem(malls: nil, shops: nil, products: products)
            let productsSection = SectionModelNew(section: "PopularProducts", items: items)
            
            guard let _ = self.bunchData?.model?["C"] else {
                self.group.enter()
                self.bunchData?.model?["C"] = productsSection
                self.group.leave()
                return
            }
            
            self.bunchData?.model?["C"] = productsSection
            self.group.leave()
        }
    }
    
    func fetchTotalData() {
        
        pathsTotalListener = []
        
        group.enter()
        pathsTotalListener.append("shopsMan")
        shopsService.fetchShops(path: "shopsMan") { shopsMan in
            guard let shopsMan = shopsMan else {
                return
            }
            self.serviceFB.shops?["Man"] = shopsMan
            self.group.leave()
        }
        
        group.enter()
        pathsTotalListener.append("shopsWoman")
        shopsService.fetchShops(path: "shopsWoman") { shopsWoman in
            guard let shopsWoman = shopsWoman else {
                return
            }
            self.serviceFB.shops?["Woman"] = shopsWoman
            self.group.leave()
        }
        
        // в модель для MapView подготовим в VC
        group.enter()
        pathsTotalListener.append("pinMals")
        pinService.fetchPin(path: "pinMals") { pins in
            guard let pins = pins else {
                return
            }
            self.serviceFB.pinMall = pins
            self.group.leave()
        }
    }
    
    // если на CartVC и ProductVC currentCartProducts == nil делаем getCartProducts
    func listenerCartProducts() {
        serviceFB.listenForUserID { userID in
            self.serviceFB.removeListenerForCardProducts()
            self.serviceFB.currentUserID = userID
            self.serviceFB.fetchCartProducts { cartProducts in
                self.serviceFB.currentCartProducts = cartProducts
            }
        }
    }
    
    
    
}

class PreviewCloudFirestoreService {
    
    
    func fetchPreviewSection(path: String, completion: @escaping ([PreviewSectionNew]?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchPreviewDataResponse(documents: documents)
                completion(response.items)
            } catch {
                //                ManagerFB.shared.CrashlyticsMethod
                completion(nil)
            }
            
        }
    }
    
    //    static func removeListeners(for path: String) {
    //        ManagerFB.shared.removeListeners(for: path)
    //    }
}

struct FetchPreviewDataResponse {
    typealias JSON = [String : Any]
    let items:[PreviewSectionNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
        
        var items = [PreviewSectionNew]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = PreviewSectionNew(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class ProductCloudFirestoreService {
   
    
    func fetchProducts(path: String, completion: @escaping ([ProductItemNew]?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil)
            }
            
        }
    }
    
//    static func removeListeners(for path: String) {
//        ManagerFB.shared.removeListeners(for: path)
//    }
}



struct FetchProductsDataResponse {
    typealias JSON = [String : Any]
    let items:[ProductItemNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
//        HomeScreenCloudFirestoreService.
        var items = [ProductItemNew]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = ProductItemNew(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class ShopsCloudFirestoreService {
    
    func fetchShops(path: String, completion: @escaping ([ShopNew]?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchShopDataResponse(documents: documents)
                completion(response.items)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil)
            }
            
        }
    }
    
//    static func removeListeners(for path: String) {
//        ManagerFB.shared.removeListeners(for: path)
//    }
}

struct FetchShopDataResponse {
    typealias JSON = [String : Any]
    let items:[ShopNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
        
        var items = [ShopNew]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = ShopNew(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class PinCloudFirestoreService {
    
    func fetchPin(path: String, completion: @escaping ([PinNew]?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchPinDataResponse(documents: documents)
                completion(response.items)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil)
            }
            
        }
    }
    
//    static func removeListeners(for path: String) {
//        ManagerFB.shared.removeListeners(for: path)
//    }
}

struct FetchPinDataResponse {
    typealias JSON = [String : Any]
    let items:[PinNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
        
        var items = [PinNew]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = PinNew(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

