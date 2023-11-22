//
//  ModelLayerMyProject.swift
//  FirstObserver
//
//  Created by Evgenyi on 27.10.23.
//



// MARK: Trash
//    var stateDataSource: StateFirstStart = .firstStart
    
//    enum StateFirstStart {
//        case firstStart
//        case secondStart
//    }
    

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import MapKit




// MARK: - Application Model -

// Controller

extension UIViewController {
    
    func showErrorAlert(message: String, state: StateDataSource, tryActionHandler: @escaping () -> Void, cancelActionHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let tryAction = UIAlertAction(title: "Try agayn", style: .cancel) { _ in
            tryActionHandler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelActionHandler?()
        }
        switch state {
            
        case .firstDataUpdate:
            alert.addAction(tryAction)
        case .followingDataUpdate:
            alert.addAction(tryAction)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true)
    }
}

// Models

enum NetworkError: Error {
    case failParsingJSON(String)
}

enum ListenerErrorState {
    case restartFetchCartProducts
    case restartObserveUser
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
    private var handle: AuthStateDidChangeListenerHandle?
    private var listeners: [String:ListenerRegistration] = [:]
    
    var currentUserID:String?
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    var currentCartProducts:[ProductItemNew]? {
        didSet {
            updateCartProducts()
        }
    }
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
    
    func updateCartProducts() {
        NotificationCenter.default.post(name: Notification.Name("UpdateCartProducts"), object: nil)
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
            // !querySnapshot.isEmpty ??????????
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
    
    func userIsAnonymously(completionHandler: @escaping (Bool?) -> Void) {
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func userListener(currentUser: @escaping (User?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            currentUser(user)
        }

    }
    
    func removeStateDidChangeListener() {
                if let handle = handle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
    }
    
    
    // MARK: UserListener + FetchCartProducts

    /// оповещаем  VCs(Home, Cart, Profile) (через NotificationCenter) об ощибках при получении user и cartProducts
    /// оповещаем  model homeVC(через NotificationCenter) о том что мы получили user и его cartProducts и инициализируем получение следующих данных
    
    func observeUserAndCardProducts() {
        /// .tooManyRequests(anonimus) + .logIn
        updateUser { error, state in
            
            if let error = error, let state = state  {
                
                    let userInfo: [String: Any] = ["error": error, "enumValue": state]
                    NotificationCenter.default.post(name: NSNotification.Name("ErrorObserveUserAndCardProductsNotification"), object: nil, userInfo: userInfo)
            } else {
                self.fetchCartProducts()
            }
        }
    }
    
    func updateUser(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
    
        userListener { user in
            if let _ = user {
                // можем делать его пустым currentCartProducts = []
                // потому что его состояние контролируется.
                self.currentCartProducts = nil
                self.setupCartProducts { error, state in
                    completion(error, state)
                }
            } else {
                self.signInAnonymously { error, state in
                    guard let error = error else { return }
                    completion(error,state)
                }
            }
        }
    }
    
    func signInAnonymously(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
        
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let error = error else { return }
            completion(error, .restartObserveUser)
        }
    }
    
    func setupCartProducts(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(error, .restartObserveUser)
            return
        }
        
        let path = "usersAccount/\(user.uid)"
        let docRef = Firestore.firestore().document(path)
        
        docRef.getDocument { (document, error) in
            
            guard error == nil else {
                completion(error, .restartObserveUser)
                return
            }
            
            if let document = document, document.exists {
                completion(nil, nil)
            } else {
                self.addEmptyCartProducts { error, state in
                    completion(error,state)
                }
            }
        }
    }
    
    func fetchCartProducts() {
        fetchData { cartProducts, error, state in
            guard let error = error, let state = state else {
            
                    NotificationCenter.default.post(name: NSNotification.Name("FetchFirstDataNotification"), object: nil)
                self.currentCartProducts = cartProducts
                return
            }
        
            guard let _ = self.currentCartProducts else {
                let userInfo: [String: Any] = ["error": error, "enumValue": state]
                NotificationCenter.default.post(name: NSNotification.Name("ErrorObserveUserAndCardProductsNotification"), object: nil, userInfo: userInfo)
                return
            }
        }
    }
    
    func fetchData(completion: @escaping ([ProductItemNew]?, Error?, ListenerErrorState?) -> Void) {
        
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(nil, error, .restartObserveUser)
            return
        }
        
        removeListenerForCardProducts()
        currentUserID = user.uid
        
        let path = "usersAccount/\(user.uid)/cartProducts"
        
        let collection = db.collection(path)
        let quary = collection.order(by: "priorityIndex", descending: false)
        
        /// если в момент прослушивание пропадет инет придет error и те данные которые мы пропусти
        /// после подключения инета мы не получим
        /// получим только те данные которые придут после нового прослушивание
        let listener = quary.addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                completion(nil, error, .restartFetchCartProducts)
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(nil, error, .restartFetchCartProducts)
                return
            }
            
            if querySnapshot.isEmpty {
                completion([], nil, nil)
                return
            }
            var documents = [[String : Any]]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                documents.append(documentData)
            }
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items, nil, nil)
            } catch {
                completion(nil, error, .restartFetchCartProducts)
            }
        }
        listeners[path] = listener
    }
    
    func addEmptyCartProducts(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
        guard let user = currentUser else {
            let error = NSError(domain: "com.yourapp.error", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not authorized."])
            completion(error, .restartObserveUser)
            return
        }
        let usersCollection = Firestore.firestore().collection("usersAccount")
        let userDocument = usersCollection.document(user.uid)
        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
            if error != nil {
                completion(error, .restartObserveUser)
            } else {
                completion(nil, nil)
            }
        }
    }
}


// MARK: - Screens -



// MARK: - HomeVC


// Протокол для модели данных
protocol HomeModelInput: AnyObject {
    func fetchGenderData()
    func firstFetchData()
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
    func observeUserAndCardProducts()
    func restartFetchCartProducts()

}

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
    func updateData(data: [String:SectionModelNew]?, error: Error?)
}

enum StateDataSource {
    case firstDataUpdate
    case followingDataUpdate
}

// Controller

class AbstractHomeViewController: PlaceholderNavigationController {
    
    private var homeModel: HomeModelInput?
    
    var stateDataSource: StateDataSource = .firstDataUpdate
    var homeDataSource:[String : SectionModelNew] = [:] {
        didSet {
            
        }
    }
    
    // нужно попробывать startSpiner как на placeholder так и на view
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    

    private func startLoad() {
        startSpiner()
        disableControls()
        //        homeModel?.startTimer()
    }
    
    private func stopLoad() {
        stopSpiner()
        enableControls()
//        homeModel?.stopTimer()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        homeModel = HomeFirebaseService(output: self)
        checkConnectionAndSetupModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
        NotificationCenter.default.addObserver(self, selector: #selector(handleErrorObserveUserAndCardProductsNotification(_:)), name: NSNotification.Name("ErrorObserveUserAndCardProductsNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ErrorObserveUserAndCardProductsNotification"), object: nil)
    }
    
    @objc func handleErrorObserveUserAndCardProductsNotification(_ notification: NSNotification) {
        
        stopLoad()
        if let userInfo = notification.userInfo,
           let error = userInfo["error"] as? NSError,
           let enumValue = userInfo["enumValue"] as? ListenerErrorState {
            showErrorAlert(message: error.localizedDescription, state: self.stateDataSource) {
                self.startLoad()
                switch enumValue {
                    
                case .restartFetchCartProducts:
                    self.homeModel?.restartFetchCartProducts()
                case .restartObserveUser:
                    self.homeModel?.observeUserAndCardProducts()
                }
            }
        }
    }
    
    func checkConnectionAndSetupModel() {
            navController?.networkConnected(completion: { isConnected in
                if isConnected {
//                    navController?.hiddenPlaceholder()
                    setupModel()
                } else {
//                    navController?.showPlaceholder()
                    showErrorAlert(message: "No internet connection!", state: stateDataSource) {
                        // Повторно проверяем подключение, когда вызывается блок в showErrorAlert
                        self.checkConnectionAndSetupModel()
                    }
                }
            })
        }
    
    func setupModel() {
        startLoad()
        homeModel?.observeUserAndCardProducts()
    }
    
    func switchGender() {
        homeModel?.isSwitchGender(completion: {
            self.forceFetchGenderData()
        })
    }
    
    func forceFetchGenderData() {
        startLoad()
        homeModel?.fetchGenderData()
    }
    
    func forceFirstFetchData() {
        startLoad()
        homeModel?.firstFetchData()
    }
    
    
    func startSpiner() {
        navController?.startSpinner()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
    func disableControls() {
        // Отключите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = false
    }

    func enableControls() {
        // Включите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = true
    }
    
}



extension AbstractHomeViewController:HomeModelOutput {
    
    func updateData(data: [String:SectionModelNew]?, error: Error?) {
        stopLoad()
        
        switch self.stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                
                self.navController?.showPlaceholder()
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFirstFetchData()
                }
                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .followingDataUpdate
            self.homeDataSource = data
           
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                /// как себя вести если не получилось обновить гендер???
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.forceFetchGenderData()
                }
                return
            }
            self.homeDataSource = data
            self.homeModel?.updateModelGender()
        }
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
    let semaphoreGender = DispatchSemaphore(value: 0)
    let semaphoreRelate = DispatchSemaphore(value: 0)
    
    var pathsGenderListener = [String]()
    var pathsRelatedListener = [String]()
    
    var dataHome:[String:SectionModelNew]? {
        didSet {
            if stateDataSource == .followingDataUpdate {
                DispatchQueue.main.async {
                    self.output?.updateData(data: self.dataHome, error: nil)
                }
            }
        }
    }
    var firstErrors: [Error?] = []
    var gender:String = ""
    var stateDataSource: StateDataSource = .firstDataUpdate
    var isFirstStartSuccessful = false
    
    let previewService = PreviewCloudFirestoreService()
    let productService = ProductCloudFirestoreService()
    let shopsService = ShopsCloudFirestoreService()
    let pinService = PinCloudFirestoreService()
    
    init(output: HomeModelOutput) {
        self.output = output
        gender = serviceFB.currentGender
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetchFirstDataNotification), name: NSNotification.Name("FetchFirstDataNotification"), object: nil)
    }
    
    // help methods
    
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
    
    func removeGenderListeners() {
        pathsGenderListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
    
    func removeRelatedListeners() {
        pathsRelatedListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
    
    func deleteGenderListeners() {
        removeGenderListeners()
        pathsGenderListener = []
    }
    
    func deleteRelatedListeners() {
        removeRelatedListeners()
        pathsRelatedListener = []
    }
    
    func deleteAllListeners() {
        deleteGenderListeners()
        deleteRelatedListeners()
    }
    
    func firstError(in errors: [Error?]) -> Error? {
        return errors.compactMap { $0 }.first
    }
}

extension HomeFirebaseService: HomeModelInput {
  
    func restartFetchCartProducts() {
        serviceFB.fetchCartProducts()
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
    
    @objc func handleFetchFirstDataNotification(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FetchFirstDataNotification"), object: nil)
        firstFetchData()
    }
    
    func firstFetchData() {
        stateDataSource = .firstDataUpdate
        DispatchQueue.global().async {
            self.fetchRelatedData()
            self.fetchGender()
        }
    }
    
    func fetchGenderData() {
        stateDataSource = .firstDataUpdate
        DispatchQueue.global().async {
            self.fetchGender()
        }
    }
    
    func fetchGender() {
            
        dataHome = [:]
        deleteGenderListeners()
        
        pathsGenderListener.append("previewMalls\(gender)")
        previewService.fetchPreviewSection(path: "previewMalls\(gender)") { malls, error in
            
            let items = self.createItem(malls: malls, shops: nil, products: nil)
            let mallSection = SectionModelNew(section: "Malls", items: items)
            
            guard let _ = self.dataHome?["A"] else {
                
                if let _ = malls, error == nil {
                    self.dataHome?["A"] = mallSection
                }
                self.firstErrors.append(error)
                self.semaphoreGender.signal()
                return
            }
            
            guard let _ = malls, error == nil else {
                return
            }
            self.dataHome?["A"] = mallSection
        }
        semaphoreGender.wait()
        
        pathsGenderListener.append("previewShops\(gender)")
        previewService.fetchPreviewSection(path: "previewShops\(gender)") { shops, error in
            
            let items = self.createItem(malls: nil, shops: shops, products: nil)
            let shopSection = SectionModelNew(section: "Shops", items: items)
            
            
            guard let _ = self.dataHome?["B"] else {
                
                if let _ = shops, error == nil {
                    self.dataHome?["B"] = shopSection
                }
                self.firstErrors.append(error)
                self.semaphoreGender.signal()
                return
            }
            guard let _ = shops, error == nil else {
                return
            }
            self.dataHome?["B"] = shopSection
        }
        semaphoreGender.wait()
        
        pathsGenderListener.append("popularProducts\(gender)")
        productService.fetchProducts(path: "popularProducts\(gender)") { products, error in
            
            let items = self.createItem(malls: nil, shops: nil, products: products)
            let productsSection = SectionModelNew(section: "PopularProducts", items: items)
            
            
            guard let _ = self.dataHome?["C"] else {
               
                if let _ = products, error == nil {
                    self.dataHome?["C"] = productsSection
                }
                self.firstErrors.append(error)
                self.semaphoreGender.signal()
                return
            }
            
            guard let _ = products, error == nil else {
                return
            }

            self.dataHome?["C"] = productsSection
        }
        semaphoreGender.wait()
        
        
        DispatchQueue.main.async {
            
            let firstError = self.firstError(in: self.firstErrors)
            self.firstErrors.removeAll()
            
            guard self.dataHome?.count == 3, firstError == nil else {
                self.output?.updateData(data: self.dataHome, error: firstError)
                self.dataHome = nil
                /// при restartGender нельзя удалять всех наблюдателей!!!
                if self.stateDataSource == .firstDataUpdate, !self.isFirstStartSuccessful {
                    self.deleteAllListeners()
                } else {
                    self.deleteGenderListeners()
                }
                return
            }
            self.isFirstStartSuccessful = true
            self.stateDataSource = .followingDataUpdate
            self.output?.updateData(data: self.dataHome, error: firstError)
        }
    }
    
    func fetchRelatedData() {
        
        deleteRelatedListeners()
        
        pathsRelatedListener.append("shopsMan")
        shopsService.fetchShops(path: "shopsMan") { shopsMan, error in
            
            guard let _ = self.serviceFB.shops?["Man"] else {
                if let shopsMan = shopsMan, error == nil {
                    self.serviceFB.shops?["Man"] = shopsMan
                }
                self.firstErrors.append(error)
                self.semaphoreRelate.signal()
                return
            }
            guard let shopsMan = shopsMan, error == nil else {
                return
            }
            
            self.serviceFB.shops?["Man"] = shopsMan
        }
        semaphoreRelate.wait()
        
        pathsRelatedListener.append("shopsWoman")
        shopsService.fetchShops(path: "shopsWoman") { shopsWoman, error in
            
            guard let _ = self.serviceFB.shops?["Woman"] else {
                if let shopsWoman = shopsWoman, error == nil {
                    self.serviceFB.shops?["Woman"] = shopsWoman
                }
                self.firstErrors.append(error)
                self.semaphoreRelate.signal()
                return
            }
            guard let shopsWoman = shopsWoman, error == nil else {
                return
            }
            
            self.serviceFB.shops?["Woman"] = shopsWoman
        }
        semaphoreRelate.wait()
        
        pathsRelatedListener.append("pinMals")
        pinService.fetchPin(path: "pinMals") { pins, error in
            
            guard let _ = self.serviceFB.pinMall else {
                if let pins = pins, error == nil {
                    self.serviceFB.pinMall = pins
                }
                self.firstErrors.append(error)
                self.semaphoreRelate.signal()
                return
            }
            
            guard let pins = pins, error == nil else {
                return
            }
            self.serviceFB.pinMall = pins
        }
        semaphoreRelate.wait()
    }
    
    func observeUserAndCardProducts() {
        serviceFB.removeStateDidChangeListener()
        serviceFB.observeUserAndCardProducts()
    }
}

class PreviewCloudFirestoreService {
    
    
    func fetchPreviewSection(path: String, completion: @escaping ([PreviewSectionNew]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchPreviewDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
                //                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}

struct FetchPreviewDataResponse {
    typealias JSON = [String : Any]
    let items:[PreviewSectionNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
        
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
   
    
    func fetchProducts(path: String, completion: @escaping ([ProductItemNew]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
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
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
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
    
    func fetchShops(path: String, completion: @escaping ([ShopNew]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchShopDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}

struct FetchShopDataResponse {
    typealias JSON = [String : Any]
    let items:[ShopNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
        
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
    
    func fetchPin(path: String, completion: @escaping ([PinNew]?, Error?) -> Void) {
        
        FirebaseService.shared.fetchStartCollection(for: path) { documents, error in
            guard let documents = documents, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try FetchPinDataResponse(documents: documents)
                completion(response.items, nil)
            } catch {
//                ManagerFB.shared.CrashlyticsMethod
                completion(nil, error)
            }
            
        }
    }
}

struct FetchPinDataResponse {
    typealias JSON = [String : Any]
    let items:[PinNew]
    
    // мы можем сделать init не просто Failable а сделаем его throws
    // throws что бы он выдавал какие то ошибки если что то не получается
    init(documents: Any) throws {
        // если мы не сможем получить array то мы выплюним ошибку throw
        guard let array = documents as? [JSON] else { throw NetworkError.failParsingJSON("Failed to parse JSON")
        }
        
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

//// Протокол для модели данных
//protocol HomeModelInput: AnyObject {
//    func fetchGenderData()
//    func firstFetchData()
//    func isSwitchGender(completion: @escaping () -> Void)
//    func setGender(gender:String)
//    func updateModelGender()
//    func observeUserAndCardProducts()
//    func restartFetchCartProducts()
//
//}
//
//// Протокол для обработки полученных данных
//protocol HomeModelOutput:AnyObject {
//    func updateData(data: [String:SectionModelNew]?, error: Error?)
//}


// Протокол для модели данных
protocol CatalogModelInput: AnyObject {
    func fetchGenderData()
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
}

// Протокол для обработки полученных данных
protocol CatalogModelOutput:AnyObject {
    func updateData(data: [PreviewSectionNew]?, error: Error?)
}

// Controller

class AbstractCatalogViewController: PlaceholderNavigationController {
    
    private var catalogModel: CatalogModelInput?
    
    var collectionPath:String
    var stateDataSource: StateDataSource = .firstDataUpdate
    /// Если вы не обратитесь к isForceData в вашем ViewController, то оно не будет загружено в память(мы обратились).
    lazy var isForceData:Bool = false
    
    var dataSource:[PreviewSectionNew] = [] {
        didSet {
        }
    }
    
    // нужно попробывать startSpiner как на placeholder так и на view
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    
    init(collectionPath: String) {
            self.collectionPath = collectionPath
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder aDecoder: NSCoder) {
        collectionPath = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoad()
        catalogModel = CatalogFirebaseService(output: self, collectionPath: collectionPath)
        catalogModel?.fetchGenderData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isForceData {
            switchGender()
        } else {
            forceFetchGenderData()
        }
    }
    
    func switchGender() {
        catalogModel?.isSwitchGender(completion: {
            self.forceFetchGenderData()
        })
    }
    
    func forceFetchGenderData() {
        startLoad()
        catalogModel?.fetchGenderData()
    }
    
    func startSpiner() {
        navController?.startSpinner()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
    func disableControls() {
        // Отключите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = false
    }

    func enableControls() {
        // Включите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = true
    }
    
    private func startLoad() {
        startSpiner()
        disableControls()
        //        homeModel?.startTimer()
    }
    
    private func stopLoad() {
        stopSpiner()
        enableControls()
//        homeModel?.stopTimer()
    }
    
}

extension AbstractCatalogViewController: CatalogModelOutput {
    func updateData(data: [PreviewSectionNew]?, error: Error?) {
        
        stopLoad()
        switch stateDataSource {
            
        case .firstDataUpdate:
            guard let data = data, error == nil else {
                
                self.navController?.showPlaceholder()
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
                    self.startLoad()
                    self.catalogModel?.fetchGenderData()
                } cancelActionHandler: {
                    self.isForceData = true
                }

                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .followingDataUpdate
            self.isForceData = false
            self.dataSource = data
        case .followingDataUpdate:
            guard let data = data, error == nil else {
                /// как себя вести если не получилось обновить гендер???
                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: self.stateDataSource) {
                    self.startLoad()
                    self.catalogModel?.fetchGenderData()
                }
                return
            }
            self.dataSource = data
            self.catalogModel?.updateModelGender()
        }
    }
}

extension AbstractCatalogViewController:HeaderSegmentedControlViewDelegate {
    func didSelectSegmentControl(gender: String) {
        catalogModel?.setGender(gender: gender)
        switchGender()
    }
}


// Model

class CatalogFirebaseService {
    
    weak var output: CatalogModelOutput?
    
    let serviceFB = FirebaseService.shared
    var pathsGenderListener = [String]()
    
    var gender:String
    var collectionPath:String
    var stateDataSource: StateDataSource = .firstDataUpdate
    let previewService = PreviewCloudFirestoreService()
    
    init(output: CatalogModelOutput, collectionPath:String) {
        self.output = output
        gender = serviceFB.currentGender
        self.collectionPath = collectionPath
    }
    
    func removeGenderListeners() {
        pathsGenderListener.forEach { path in
            self.serviceFB.removeListeners(for: path)
        }
    }
}

extension CatalogFirebaseService: CatalogModelInput {
    
    func fetchGenderData() {
        removeGenderListeners()
        pathsGenderListener = []
        pathsGenderListener.append("\(collectionPath)\(gender)")
    
        previewService.fetchPreviewSection(path: "\(collectionPath)\(gender)") { items, error in
            
            guard self.stateDataSource == .followingDataUpdate else {
                if let _ = items, error == nil {
                    self.stateDataSource = .followingDataUpdate
                }
                self.output?.updateData(data: items, error: error)
                return
            }
            guard let items = items, error == nil else {
                return
            }
            self.output?.updateData(data: items, error: error)
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



// MARK: - CartVC


// Протокол для модели данных
protocol CartModelInput: AnyObject {
    func fetchDataSource(completion: @escaping ([ProductItemNew]?) -> Void)
    func userIsAnonymously(completion: @escaping (Bool?) -> Void)
}


// Протокол для обработки полученных данных
protocol CartModelOutput:AnyObject {
    func startSpiner()
    func stopSpiner()
    func disableControls()
    func enableControls()
}

// Controller

extension AbstractCartViewController: CartModelOutput {
    
    func startSpiner() {
        navController?.startSpinner()
    }
    
    func stopSpiner() {
        navController?.stopSpinner()
    }
    
    func disableControls() {
        // Отключите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = false
    }

    func enableControls() {
        // Включите все элементы управления
        // Например, если у вас есть кнопка:
        // myButton.isEnabled = true
    }
    
}

class AbstractCartViewController: PlaceholderNavigationController {
    
    private var cartModel: CartModelInput?
    
    var dataSource:[ProductItemNew]? {
        didSet {
//            self?.tableView.reloadData()
        }
    }
    private var isAnonymouslyUser = false

    
    // нужно попробывать startSpiner как на placeholder так и на view
    var navController: PlaceholderNavigationController? {
            return self.navigationController as? PlaceholderNavigationController
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func updateData() {
        cartModel?.userIsAnonymously{ isAnonymously in
            guard let isAnonymously = isAnonymously else {
                self.isAnonymouslyUser = false
                self.dataSource = []
                return
            }
            self.isAnonymouslyUser = isAnonymously
            self.cartModel?.fetchDataSource{ cartProducts in
                guard let cartProducts = cartProducts else {
                    self.dataSource = []
                    return
                }
                self.dataSource = cartProducts
            }
        }
    }
    
}

// Model

class CartFirebaseService {
    
    weak var output: CartModelOutput?
    
    let serviceFB = FirebaseService.shared
    
    init(output: CartModelOutput) {
        self.output = output
    }
}

extension CartFirebaseService: CartModelInput {
    
    func userIsAnonymously(completion: @escaping (Bool?) -> Void) {
        serviceFB.userIsAnonymously { isAnonymously in
            completion(isAnonymously)
        }
    }
    
    func fetchDataSource(completion: @escaping ([ProductItemNew]?) -> Void) {
        completion(serviceFB.currentCartProducts)
    }
    
}
