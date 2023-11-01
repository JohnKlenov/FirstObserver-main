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
    
    
    // MARK: - helper methods
    
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

//  Listener user

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Прослушивание изменений состояния пользователя
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if let user = user {
//                // Если пользователь уже вошел в систему, используйте его uid
//                self.setupCartProducts(for: user.uid)
//            } else {
//                // Если пользователь еще не вошел в систему, создайте анонимного пользователя
//                Auth.auth().signInAnonymously { (authResult, error) in
//                    if let error = error {
//                        self.showErrorAlert(message: "Ошибка создания анонимного пользователя: \(error.localizedDescription)")
//                    } else if let user = authResult?.user {
//                        self.setupCartProducts(for: user.uid)
//                    }
//                }
//            }
//        }
//    }
//
//    func setupCartProducts(for uid: String) {
//        let db = Firestore.firestore()
//        let usersCollection = db.collection("usersAccount")
//        let userDocument = usersCollection.document(uid)
//
//        // Проверьте, существует ли уже документ для этого пользователя
//        userDocument.getDocument { (document, error) in
//            if let error = error {
//                self.showErrorAlert(message: "Ошибка получения документа пользователя: \(error.localizedDescription)")
//            } else if let document = document, document.exists {
//                // Документ уже существует, поэтому ничего не делайте
//            } else {
//                // Документ не существует, поэтому создайте новый документ и коллекцию cartProducts
//                userDocument.setData([:]) { error in
//                    if let error = error {
//                        self.showErrorAlert(message: "Ошибка создания документа пользователя: \(error.localizedDescription)")
//                    } else {
//                        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
//                            if let error = error {
//                                self.showErrorAlert(message: "Ошибка создания cartProducts: \(error.localizedDescription)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func showErrorAlert(message: String) {
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
//    }
//
//}
//
//class Test: ViewController {
//
//
//    func showErrorAlert(message: String, retryHandler: @escaping () -> Void) {
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
//            retryHandler()
//        })
//        self.present(alert, animated: true)
//    }
//
//    func setupCartProducts2(for uid: String) {
//        let db = Firestore.firestore()
//        let usersCollection = db.collection("usersAccount")
//        let userDocument = usersCollection.document(uid)
//
//        // Проверьте, существует ли уже документ для этого пользователя
//        userDocument.getDocument { (document, error) in
//            if let error = error {
//                self.showErrorAlert(message: "Ошибка получения документа пользователя: \(error.localizedDescription)") {
//                    self.setupCartProducts(for: uid)
//                }
//            } else if let document = document, document.exists {
//                // Документ уже существует, поэтому ничего не делайте
//            } else {
//                // Документ не существует, поэтому создайте новый документ и коллекцию cartProducts
//                userDocument.setData([:]) { error in
//                    if let error = error {
//                        self.showErrorAlert(message: "Ошибка создания документа пользователя: \(error.localizedDescription)") {
//                            self.setupCartProducts(for: uid)
//                        }
//                    } else {
//                        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
//                            if let error = error {
//                                self.showErrorAlert(message: "Ошибка создания cartProducts: \(error.localizedDescription)") {
//                                    self.setupCartProducts(for: uid)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    Auth.auth().signInAnonymously { (authResult, error) in
//        guard let user = authResult?.user, error == nil else {
//            print("Ошибка создания анонимного пользователя: \(error?.localizedDescription ?? "")")
//            // Повторите попытку через некоторое время
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.signInAnonymously()
//            }
//            return
//        }
//        self.setupCartProducts(for: user.uid)
//    }
//}

//class FirebaseManager {
//    static let shared = FirebaseManager()
//
//    func createUser(completion: @escaping (Error?) -> Void) {
//        Auth.auth().createUser(withEmail: "email@example.com", password: "password") { (authResult, error) in
//            if let error = error {
//                if let viewController = UIApplication.shared.windows.first?.rootViewController {
//                    viewController.showErrorAlert(message: error.localizedDescription)
//                }
//                completion(error)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//}
//
//extension UIViewController {
//    func showErrorAlert(message: String) {
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
//    }

//if #available(iOS 15.0, *) {
//    // Используйте UIWindowScene.windows.first?.rootViewController
//} else {
//    // Используйте UIApplication.shared.windows.first?.rootViewController
//}
//}




// MARK: - Screens -



// MARK: - HomeVC


// Протокол для модели данных
protocol HomeModelInput: AnyObject {
    func fetchGenderData()
    func fetchDataSource(completion: @escaping ([String:SectionModelNew]?) -> Void)
    func firstFetchData()
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
}

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
    func startSpiner()
    func stopSpiner()
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
    
    // нужно попробывать startSpiner как на placeholder так и на view
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeModel = HomeFirebaseService(output: self)
        homeModel?.fetchDataSource(completion: { homeDataSource in
            guard let homeDataSource = homeDataSource else {
                
                switch self.stateDataSource {
                case .firstStart:
                    self.navController?.showPlaceholder()
                    self.alertFailedFetchData(state: self.stateDataSource) {
                        self.repeatedFetchData()
                    }
                case .fetchGender:
                    self.alertFailedFetchData(state: self.stateDataSource) {
                        self.repeatedFetchData()
                    }
                }
                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .fetchGender
            // при переходе на mallVC, shopVC
            self.homeModel?.updateModelGender()
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

extension UIViewController {
   
    // alert в котором нет cancel при первом старте только HomeVC
    func alertFailedFetchData(state: StateDataSource, retryHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong!", preferredStyle: .alert)
        
        let tryAgayn = UIAlertAction(title: "Try agayn", style: .cancel) { _ in
            retryHandler()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            //
        }
        
        switch state {
            
        case .firstStart:
            alert.addAction(tryAgayn)
        case .fetchGender:
            alert.addAction(tryAgayn)
            alert.addAction(cancel)
        }
        present(alert, animated: true, completion: nil)
    }
}

extension AbstractHomeViewController:HomeModelOutput {
    func startSpiner() {
        navController?.startSpinner()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
   
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
    
    func updateModelGender() {
        gender = serviceFB.currentGender
    }
    
    func isSwitchGender(completion: @escaping () -> Void) {
        if gender != serviceFB.currentGender {
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
            self.output?.stopSpiner()
        }
    }
    
    func fetchGenderData() {
        
        output?.startSpiner()
        
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




// MARK: - Malls



// Протокол для модели данных
protocol MallsModelInput: AnyObject {
    func fetchGenderData()
    func fetchDataSource(completion: @escaping ([PreviewSectionNew]?) -> Void)
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
}

// Протокол для обработки полученных данных
protocol MallsModelOutput:AnyObject {
    func startSpiner()
    func stopSpiner()
}

// Controller

extension AbstractMsllsViewController: MallsModelOutput {
    
    func startSpiner() {
        navController?.startSpinner()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
}

class AbstractMsllsViewController: PlaceholderNavigationController {
    
    private var mallsModel: MallsModelInput?
    
    var stateDataSource: StateDataSource = .firstStart
    var mallsDataSource:[PreviewSectionNew] = [] {
        didSet {
            
        }
    }
    
    // нужно попробывать startSpiner как на placeholder так и на view
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mallsModel = MallsFirebaseService(output: self)
        mallsModel?.fetchDataSource(completion: { homeDataSource in
            guard let homeDataSource = homeDataSource else {
                
                switch self.stateDataSource {
                case .firstStart:
                    self.navController?.showPlaceholder()
                    self.alertFailedFetchData(state: self.stateDataSource) {
                        self.mallsModel?.fetchGenderData()
                    }
                case .fetchGender:
                    self.alertFailedFetchData(state: self.stateDataSource) {
                        self.mallsModel?.fetchGenderData()
                    }
                }
                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .fetchGender
            // при переходе на mallVC, shopVC
            self.mallsModel?.updateModelGender()
            self.mallsDataSource = homeDataSource
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
    }
    
    func switchGender() {
        mallsModel?.isSwitchGender(completion: {
            self.mallsModel?.fetchGenderData()
        })
    }
}


// Model

class MallsFirebaseService {
    
    weak var output: MallsModelOutput?
    
    let serviceFB = FirebaseService.shared
    let group = DispatchGroup()
    var timer: Timer?
    var pathsGenderListener = [String]()
    
    var gender:String = ""
    var mallsDataSource:[PreviewSectionNew]?
    let previewService = PreviewCloudFirestoreService()
    
    init(output: MallsModelOutput) {
        self.output = output
        gender = serviceFB.currentGender
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            
            self.pathsGenderListener.forEach { path in
                self.mallsDataSource = nil
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

extension MallsFirebaseService: MallsModelInput {
    
    func fetchGenderData() {
       
        output?.startSpiner()
        mallsDataSource = []
        removeGenderListeners()
        pathsGenderListener = []
        startTimer()
        pathsGenderListener.append("catalogMalls\(gender)")
        
        group.enter()
        // так мы перезаписывем previeMall(добавляем catalogMalls в cloudFirestore) а вдруг у нас будет банер рекламный на previewMall? :) на HomeVC + gender под вопросом
        previewService.fetchPreviewSection(path: "catalogMalls\(gender)") { malls in
            guard let malls = malls else {
                return
            }
            self.mallsDataSource = malls
            self.group.leave()
        }
    }
    
    
    func fetchDataSource(completion: @escaping ([PreviewSectionNew]?) -> Void) {
        fetchGenderData()
        group.notify(queue: .main) {
            self.timer?.invalidate()
            self.output?.stopSpiner()
            completion(self.mallsDataSource)
        }
    }
    
    
    func setGender(gender: String) {
        serviceFB.setGender(gender: gender)
    }
    
    func updateModelGender() {
        gender = serviceFB.currentGender
    }
    
    func isSwitchGender(completion: @escaping () -> Void) {
        if gender != serviceFB.currentGender {
            completion()
        }
    }
    
}
