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

enum NetworkError2: Error {
    case failInternetError
    case noInternetConnection
}

struct ItemNew2: Hashable {
    let mall: PreviewSectionNew2?
    let shop: PreviewSectionNew2?
    let popularProduct: ProductItemNew2?
//    let mallImage: String?
}

struct PreviewSectionNew2: Hashable {
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

struct SectionModelNew2: Hashable {
    let section: String
    var items: [ItemNew2]
}


struct ShopNew2 {
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

struct ProductItemNew2: Hashable {
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

struct PinNew2 {
    
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

class PinMapNew2: NSObject, MKAnnotation {

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

class BunchData2 {
    var model:[String:SectionModelNew2]?
    var shops:[String:[ShopNew2]]?
    var cartProducts: [ProductItemNew2]?
    var pinMall: [PinNew2]?
}




final class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    private var listeners: [String:ListenerRegistration] = [:]
    
    var currentUserID:String?
    var currentCartProducts:[ProductItemNew]?
   
    
    
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
//    func fetchData()
    func listenerCartProducts()
    func fetchBunchData(gender: String, completion: @escaping ([String:SectionModelNew2]) -> Void)
}

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
//    func didFetchData(data: Any)
}

// Controller

class AbstractHomeViewController: UIViewController {
    
    private var homeModel: HomeModelInput?
    
    var currentGender:String!
    let defaults = UserDefaults.standard
    
    var homeDataSource:[String : SectionModelNew] = [:] {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeModel = HomeFirebaseService(output: self)
    }
    
}

extension AbstractHomeViewController:HomeModelOutput {
   
}


// Model

class HomeFirebaseService {
    
    weak var output: HomeModelOutput?
    
    let serviceFB = FirebaseService.shared
    let group = DispatchGroup()
    var bunchData = BunchData2()
    
    let previewService = PreviewCloudFirestoreService2()
    let productService = ProductCloudFirestoreService2()
    let shopsService = ShopsCloudFirestoreService2()
    let pinService = PinCloudFirestoreService2()
    
    init(output: HomeModelOutput) {
        self.output = output
    }
    
    func createItem(malls: [PreviewSectionNew2]? = nil, shops: [PreviewSectionNew2]? = nil, products: [ProductItemNew2]? = nil) -> [ItemNew2] {
        
        var items = [ItemNew2]()
        if let malls = malls {
            items = malls.map {ItemNew2(mall: $0, shop: nil, popularProduct: nil)}
        } else if let shops = shops {
            items = shops.map {ItemNew2(mall: nil, shop: $0, popularProduct: nil)}
        } else if let products = products {
            items = products.map {ItemNew2(mall: nil, shop: nil, popularProduct: $0)}
        }
        return items
    }
}

extension HomeFirebaseService: HomeModelInput {
    
    
    
    func fetchBunchData(gender: String, completion: @escaping ([String : SectionModelNew2]) -> Void) {
        
        group.enter()
        previewService.fetchPreviewSection(path: "previewMalls\(gender)") { malls in
            guard let malls = malls else {
                return
            }
            
            let items = self.createItem(malls: malls, shops: nil, products: nil)
            let mallSection = SectionModelNew2(section: "Malls", items: items)
            
            guard let _ = self.bunchData.model?["A"] else {
                self.group.enter()
                self.bunchData.model?["A"] = mallSection
                self.group.leave()
                return
            }
            
            self.bunchData.model?["A"] = mallSection
            self.group.leave()
        }
        
        group.enter()
        previewService.fetchPreviewSection(path: "previewShops\(gender)") { shops in
            
            guard let shops = shops else {
                return
            }
            
            let items = self.createItem(malls: nil, shops: shops, products: nil)
            let shopSection = SectionModelNew2(section: "Shops", items: items)
            
            guard let _ = self.bunchData.model?["B"] else {
                self.group.enter()
                self.bunchData.model?["B"] = shopSection
                self.group.leave()
                return
            }
            
            self.bunchData.model?["B"] = shopSection
            self.group.leave()
        }
        
        group.enter()
        productService.fetchProducts(path: "popularProducts\(gender)") { products in
            guard let products = products else {
                return
            }
            
            let items = self.createItem(malls: nil, shops: nil, products: products)
            let productsSection = SectionModelNew2(section: "PopularProducts", items: items)
            
            guard let _ = self.bunchData.model?["C"] else {
                self.group.enter()
                self.bunchData.model?["C"] = productsSection
                self.group.leave()
                return
            }
            
            self.bunchData.model?["C"] = productsSection
            self.group.leave()
        }
        
        group.enter()
        shopsService.fetchShops(path: "shopsMan") { shopsMan in
            guard let shopsMan = shopsMan else {
                return
            }

            guard let _ = self.bunchData.shops?["Man"] else {
                self.group.enter()
                self.bunchData.shops?["Man"] = shopsMan
                self.group.leave()
                return
            }

            self.bunchData.shops?["Man"] = shopsMan
            self.group.leave()
        }
        
        group.enter()
        shopsService.fetchShops(path: "shopsWoman") { shopsWoman in
            guard let shopsWoman = shopsWoman else {
                return
            }

            guard let _ = self.bunchData.shops?["Woman"] else {
                self.group.enter()
                self.bunchData.shops?["Woman"] = shopsWoman
                self.group.leave()
                return
            }

            self.bunchData.shops?["Woman"] = shopsWoman
            self.group.leave()
        }
        
        // в модель для MapView подготовим в VC
        group.enter()
        pinService.fetchPin(path: "pinMals") { pins in
            guard let pins = pins else {
                return
            }
            
            guard let _ = self.bunchData.pinMall else {
                self.group.enter()
                self.bunchData.pinMall = pins
                self.group.leave()
                return
            }
            
            self.bunchData.pinMall = pins
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            completion(self.bunchData.model ?? [:])
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

class PreviewCloudFirestoreService2 {
    
    
    func fetchPreviewSection(path: String, completion: @escaping ([PreviewSectionNew2]?) -> Void) {
        
        ManagerFB.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchPreviewDataResponse2(documents: documents)
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

struct FetchPreviewDataResponse2 {
    typealias JSON = [String : Any]
    let items:[PreviewSectionNew2]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
        
        var items = [PreviewSectionNew2]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = PreviewSectionNew2(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class ProductCloudFirestoreService2 {
   
    
    func fetchProducts(path: String, completion: @escaping ([ProductItemNew2]?) -> Void) {
        
        ManagerFB.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse2(documents: documents)
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



struct FetchProductsDataResponse2 {
    typealias JSON = [String : Any]
    let items:[ProductItemNew2]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
//        HomeScreenCloudFirestoreService.
        var items = [ProductItemNew2]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = ProductItemNew2(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class ShopsCloudFirestoreService2 {
    
    func fetchShops(path: String, completion: @escaping ([ShopNew2]?) -> Void) {
        
        ManagerFB.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchShopDataResponse2(documents: documents)
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

struct FetchShopDataResponse2 {
    typealias JSON = [String : Any]
    let items:[ShopNew2]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
        
        var items = [ShopNew2]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = ShopNew2(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

class PinCloudFirestoreService2 {
    
    func fetchPin(path: String, completion: @escaping ([PinNew2]?) -> Void) {
        
        ManagerFB.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents else {
                completion(nil)
                return
            }
            
            do {
                let response = try FetchPinDataResponse2(documents: documents)
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

struct FetchPinDataResponse2 {
    typealias JSON = [String : Any]
    let items:[PinNew2]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failInternetError }
        
        var items = [PinNew2]()
        for dictionary in array {
            // если у нас не получился comment то просто продолжаем - continue
            // потому что тут целый массив и малали один не получился остальные получаться
            let item = PinNew2(dict: dictionary)
            items.append(item)
        }
        self.items = items
    }
}

