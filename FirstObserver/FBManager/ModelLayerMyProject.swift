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

// Controller

extension UIViewController {
    func showErrorAlert2(message: String, retryHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            retryHandler()
        })
        self.present(alert, animated: true)
    }

//if #available(iOS 15.0, *) {
//    // Используйте UIWindowScene.windows.first?.rootViewController
//} else {
//    // Используйте UIApplication.shared.windows.first?.rootViewController
//}
//    if let error = error {
    //                if let viewController = UIApplication.shared.windows.first?.rootViewController {
    //                    viewController.showErrorAlert(message: error.localizedDescription)
    //                }
}

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
    
//    lazy var onFetchCartPRoducts: (() -> Void) = {
//        self.fetchCartProducts { cartProducts in
//            self.currentCartProducts = cartProducts
////         инициализируем вызов второй порции данных
//            switch self.stateStart {
//
//            case .firstStart:
//                // может быть через NSNotification.Name
//                // и при удачной загрузки первого цикла отключаем наблюдателя
//                print("инициализируем вызов второй порции данных")
//            case .secondStart:
//                print("")
//            }
//        }
//    }
    
    var stateStart: StateFirstStart = .firstStart
    
    enum StateFirstStart {
        case firstStart
        case secondStart
    }
    
    
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
    
    
    func userListener(currentUser: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
//            self.currentUser = user
            currentUser(user)
        }
    }
    
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
                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
                // if failad create addEmptyCartProducts -> call addEmptyCartProducts()
            } else {
                // for second version
                self.fetchCartProducts2()
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
    
    // my version 2
    
//    func listenerCartProducts() {
//        serviceFB.listenForUserID { userID in
//            self.serviceFB.removeListenerForCardProducts()
//            self.serviceFB.currentUserID = userID
//            self.serviceFB.fetchCartProducts { cartProducts in
//                self.serviceFB.currentCartProducts = cartProducts
//            }
//        }
//    }

    var handle: AuthStateDidChangeListenerHandle?
    
    func userListenerHandle(currentUser: @escaping (User?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            currentUser(user)
        }

    }
    
    func removeStateDidChangeListener() {
                if let handle = handle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
    }
    
    func signInAnonymouslyUser() {
        
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let _ = error else {return}
            print("Returne message for analitic FB Crashlystics")
            // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
            // if failad create AnonymouslyUser -> call signInAnonymouslyUser()
        }
    }
    
    // userListener имеет наблюдателя и если мы при первом старте во viewDidLoad в течении 15 секунд не получаем ответа от сервера , отключаем наблюдателя и выкидываем alert
    func listenerUser() {
        userListenerHandle { user in
            if let _ = user {
                self.currentCartProducts = nil
                self.setupCartProducts()
            } else {
                self.signInAnonymouslyUser()
            }
        }
    }
    
    // точка входа для второй порции данных - addEmptyCartProducts
    // fetchCartProducts вызывается тогда когда есть user и путь до него
    func setupCartProducts() {
        // а можем ли мы перенести эти строки в onFetchCartPRoducts?
        guard let user = Auth.auth().currentUser else {
            // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: nil)
            // if user == nil -> signIn,
            return
        }
        removeListenerForCardProducts()
        currentUserID = user.uid
        let path = "usersAccount/\(String(describing: currentUserID))"
        let docRef = Firestore.firestore().document(path)
        
        // нужно обработать ошибку
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exists!")
                self.fetchCartProducts2()
            } else {
                print("Document does not exist!")
                // если все ок то self.fetchCartProducts
                self.addEmptyCartProducts(uid: self.currentUserID ?? "" )
            }
        }
    }
    
    func fetchCartProducts2() {
        fetchData { cartProducts in
            self.currentCartProducts = cartProducts
//         инициализируем вызов второй порции данных
            switch self.stateStart {
                
            case .firstStart:
                // может быть через NSNotification.Name
                // и при удачной загрузки первого цикла отключаем наблюдателя
                print("инициализируем вызов второй порции данных")
            case .secondStart:
                print("")
            }
        }
    }
    
    func fetchData(completion: @escaping ([ProductItemNew]) -> Void) {
        
        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
        
        let collection = db.collection(path)
        let quary = collection.order(by: "priorityIndex", descending: false)
        
        let listener = quary.addSnapshotListener { (querySnapshot, error) in
            
            if let _ = error {
                print("Returned message for analytic FB Crashlytics error")
                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
                // if failad fetchCartProducts2() -> call setupCartProducts()
                return
            }
            guard let querySnapshot = querySnapshot else {
                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
                // if failad fetchCartProducts2() -> call setupCartProducts()
                return
            }
            var documents = [[String : Any]]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                documents.append(documentData)
            }
            do {
                let response = try FetchProductsDataResponse(documents: documents)
                completion(response.items)
            } catch {
                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
                // if failad fetchCartProducts2() -> call setupCartProducts()
            }
        }
        listeners[path] = listener
    }
}



//  Listener user

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // my version
        
        

        // Прослушивание изменений состояния пользователя
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // Если пользователь уже вошел в систему, используйте его uid
                self.setupCartProducts(for: user.uid)
            } else {
                // Если пользователь еще не вошел в систему, создайте анонимного пользователя
                Auth.auth().signInAnonymously { (authResult, error) in
                    if let error = error {
                        self.showErrorAlert(message: "Ошибка создания анонимного пользователя: \(error.localizedDescription)")
                    } else if let user = authResult?.user {
                        self.setupCartProducts(for: user.uid)
                    }
                }
            }
        }
    }

    func setupCartProducts(for uid: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("usersAccount")
        let userDocument = usersCollection.document(uid)

        // Проверьте, существует ли уже документ для этого пользователя
        userDocument.getDocument { (document, error) in
            if let error = error {
                self.showErrorAlert(message: "Ошибка получения документа пользователя: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                // Документ уже существует, поэтому ничего не делайте
            } else {
                // Документ не существует, поэтому создайте новый документ и коллекцию cartProducts
                userDocument.setData([:]) { error in
                    if let error = error {
                        self.showErrorAlert(message: "Ошибка создания документа пользователя: \(error.localizedDescription)")
                    } else {
                        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
                            if let error = error {
                                self.showErrorAlert(message: "Ошибка создания cartProducts: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}

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
//
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
    func listenerCartProducts2()
}

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
    func startSpiner()
    func stopSpiner()
    func disableControls()
    func enableControls()
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
            self.timer?.invalidate()
            self.output?.stopSpiner()
            self.output?.enableControls()
            completion(self.bunchData?.model)
        }
    }
    
    func fetchGenderData() {
        
        output?.disableControls()
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
    
    func listenerCartProducts2() {
//        serviceFB
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
protocol CatalogModelInput: AnyObject {
    func fetchGenderData()
    func fetchDataSource(completion: @escaping ([PreviewSectionNew]?) -> Void)
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
}

// Протокол для обработки полученных данных
protocol CatalogModelOutput:AnyObject {
    func startSpiner()
    func stopSpiner()
    func disableControls()
    func enableControls()
}

// Controller

extension AbstractCatalogViewController: CatalogModelOutput {
    
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

class AbstractCatalogViewController: PlaceholderNavigationController {
    
    private var catalogModel: CatalogModelInput?
    
    var collectionPath:String
    var stateDataSource: StateDataSource = .firstStart
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
        
        catalogModel = CatalogFirebaseService(output: self, collectionPath: collectionPath)
        catalogModel?.fetchDataSource(completion: { dataSource in
            guard let dataSource = dataSource else {
                
                switch self.stateDataSource {
                case .firstStart:
                    self.navController?.showPlaceholder()
                    self.alertFailedFetchData(state: self.stateDataSource) {
                        self.catalogModel?.fetchGenderData()
                    }
                case .fetchGender:
                    // можем возвращать из этого места segmentControl на актуальное значение во view
                    self.alertFailedFetchData(state: self.stateDataSource) {
                        self.catalogModel?.fetchGenderData()
                    }
                }
                return
            }
            self.navController?.hiddenPlaceholder()
            self.stateDataSource = .fetchGender
            // при переходе на mallVC, shopVC
            self.catalogModel?.updateModelGender()
            self.dataSource = dataSource
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
    }
    
    func switchGender() {
        catalogModel?.isSwitchGender(completion: {
            self.catalogModel?.fetchGenderData()
        })
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
    let group = DispatchGroup()
    var timer: Timer?
    var pathsGenderListener = [String]()
    
    var gender:String
    var collectionPath:String
    var dataSource:[PreviewSectionNew]?
    let previewService = PreviewCloudFirestoreService()
    
    init(output: CatalogModelOutput, collectionPath:String) {
        self.output = output
        gender = serviceFB.currentGender
        self.collectionPath = collectionPath
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            
            self.pathsGenderListener.forEach { path in
                self.dataSource = nil
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

extension CatalogFirebaseService: CatalogModelInput {
    
    func fetchGenderData() {
        output?.disableControls()
        output?.startSpiner()
        dataSource = []
        removeGenderListeners()
        pathsGenderListener = []
        startTimer()
        pathsGenderListener.append("\(collectionPath)\(gender)")
        
        group.enter()
        // так мы перезаписывем previeMall(добавляем catalogMalls в cloudFirestore) а вдруг у нас будет банер рекламный на previewMall? :) на HomeVC + gender под вопросом
        previewService.fetchPreviewSection(path: "\(collectionPath)\(gender)") { items in
            guard let items = items else {
                return
            }
            self.dataSource = items
            self.group.leave()
        }
    }
    
    
    func fetchDataSource(completion: @escaping ([PreviewSectionNew]?) -> Void) {
        fetchGenderData()
        group.notify(queue: .main) {
            self.timer?.invalidate()
            self.output?.stopSpiner()
            self.output?.enableControls()
            completion(self.dataSource)
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