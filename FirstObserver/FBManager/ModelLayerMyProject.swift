//
//  ModelLayerMyProject.swift
//  FirstObserver
//
//  Created by Evgenyi on 27.10.23.
//



// MARK: Trash

//    func listenForUserID(completion: @escaping (String) -> Void) {
//        userListener { currentUser in
//            guard let currentUser = currentUser else {
//                self.currentCartProducts = nil
//                self.signInAnonymously()
//                return
//            }
//            completion(currentUser.uid)
//        }
//    }

//    func signInAnonymously() {
//
//        Auth.auth().signInAnonymously { (authResult, error) in
//
//            guard error == nil, let authResult = authResult else {
//                print("Returne message for analitic FB Crashlystics")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.signInAnonymously()
//                }
//                return
//            }
//            self.addEmptyCartProducts(uid: authResult.user.uid)
//        }
//    }
// переделали
//    // userListener имеет наблюдателя и если мы при первом старте во viewDidLoad в течении 15
////    секунд не получаем ответа от сервера , отключаем наблюдателя и выкидываем alert
//    func listenerUser() {
//        userListener { user in
//            if let _ = user {
//                self.currentCartProducts = nil
//                self.setupCartProducts()
//            } else {
//                self.signInAnonymously()
//            }
//        }
//    }
//
//    // переделали
//    func signInAnonymously() {
//
//        Auth.auth().signInAnonymously { (authResult, error) in
//            guard let _ = error else {return}
//            print("Returne message for analitic FB Crashlystics")
//            // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
//            // if failad create AnonymouslyUser -> call signInAnonymouslyUser()
//        }
//    }
//
////    self.signInAnonymously2 { erorr in
////        guard let error = error else {return}
////        // completion(error)
////    }
////    func signInAnonymously2(completion: @escaping (Error?) -> Void) {
////
////        Auth.auth().signInAnonymously {  (authResult, error) in
////            completion(error)
////        }
////    }
//    // переделали
//    func addEmptyCartProducts(uid: String) {
//
//        let usersCollection = Firestore.firestore().collection("usersAccount")
//        let userDocument = usersCollection.document(uid)
//        userDocument.collection("cartProducts").addDocument(data: [:]) { error in
//            if error != nil {
//                print("Returne message for analitic FB Crashlystics")
//                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
//                // if failad create addEmptyCartProducts -> call addEmptyCartProducts()
//            } else {
//                // for second version
//                self.fetchCartProducts()
//            }
//        }
//    }
//
//    // переделали
//    // точка входа для второй порции данных - addEmptyCartProducts
//    func setupCartProducts() {
//        guard let user = Auth.auth().currentUser else {
//            // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: nil)
//            // if user == nil -> signIn,
//            return
//        }
//        removeListenerForCardProducts()
//        currentUserID = user.uid
//        let path = "usersAccount/\(String(describing: currentUserID))"
//        let docRef = Firestore.firestore().document(path)
//
//        // нужно обработать ошибку
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                print("Document exists!")
//                self.fetchCartProducts()
//            } else {
//                print("Document does not exist!")
//                // если все ок то self.fetchCartProducts
//                self.addEmptyCartProducts(uid: self.currentUserID ?? "" )
//            }
//        }
//    }
//    // переделали
//    func fetchCartProducts() {
//        fetchData { cartProducts in
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
//    // передеали
//    func fetchData(completion: @escaping ([ProductItemNew]) -> Void) {
//
//        let path = "usersAccount/\(String(describing: currentUserID))/cartProducts"
//
//        let collection = db.collection(path)
//        let quary = collection.order(by: "priorityIndex", descending: false)
//
//        let listener = quary.addSnapshotListener { (querySnapshot, error) in
//
//            if let _ = error {
//                print("Returned message for analytic FB Crashlytics error")
//                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
//                // if failad fetchCartProducts2() -> call setupCartProducts()
//                return
//            }
//            guard let querySnapshot = querySnapshot else {
//                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
//                // if failad fetchCartProducts2() -> call setupCartProducts()
//                return
//            }
//            var documents = [[String : Any]]()
//
//            for document in querySnapshot.documents {
//                let documentData = document.data()
//                documents.append(documentData)
//            }
//            do {
//                let response = try FetchProductsDataResponse(documents: documents)
//                completion(response.items)
//            } catch {
//                // NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
//                // if failad fetchCartProducts2() -> call setupCartProducts()
//            }
//        }
//        listeners[path] = listener
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
    
    func showErrorAlert(message: String, state: StateDataSource, retryHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let tryAction = UIAlertAction(title: "Try agayn", style: .cancel) { _ in
            retryHandler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            //
        }
        switch state {
            
        case .firstStart:
            alert.addAction(tryAction)
        case .fetchGender:
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
    
    
    var stateDataSource: StateFirstStart = .firstStart
    
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
                    NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: nil, userInfo: userInfo)
            } else {
                self.fetchCartProducts()
            }
        }
    }
    
    func someFunction(completion: ((Bool) -> Void)? = nil) {
        // Ваш код здесь
        completion?(true)
    }
    
    func updateUser(completion: @escaping (Error?, ListenerErrorState?) -> Void) {
    
        someFunction()
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
                
                if self.stateDataSource == .firstStart {
                    self.stateDataSource = .secondStart
                    NotificationCenter.default.post(name: NSNotification.Name("FetchUserAndCartProductDataNotification"), object: nil)
                }
                self.currentCartProducts = cartProducts
                return
            }
            // не получилось получить cartProducts при первом старте
            // а если ошибка произошла в момент наблюдения за карзиной?
            // нужно отключать оповещение об error после успешного fetchCartProducts
            // ставить флаг open на получении users и clouse когда мы получаем currentCartProducts или так если currentCartProducts == nil то отправляем ошибки иначе нет!
            guard let _ = self.currentCartProducts else {
                let userInfo: [String: Any] = ["error": error, "enumValue": state]
                NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: nil, userInfo: userInfo)
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
    func fetchDataSource()
    func firstFetchData()
    func isSwitchGender(completion: @escaping () -> Void)
    func setGender(gender:String)
    func updateModelGender()
    func observeUserAndCardProducts()
    func restartFetchCartProducts()
//    func startTimer()
//    func stopTimer()
}

// Протокол для обработки полученных данных
protocol HomeModelOutput:AnyObject {
    func updateData(data: [String:SectionModelNew]?, error: Error?)
//    func startSpiner()
//    func stopSpiner()
//    func disableControls()
//    func enableControls()
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
        
        startLoad()
        homeModel = HomeFirebaseService(output: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchGender()
        NotificationCenter.default.addObserver(self, selector: #selector(handleErrorNotification(_:)), name: NSNotification.Name("ErrorNotification"), object: nil)
    }
    
    ///  work at errors ! and implemintation scenry
    @objc func handleErrorNotification(_ notification: NSNotification) {
        // срабатывает когда мы visible
//        if self.isViewLoaded && self.view.window != nil {
//               // Контроллер видимый, выполняем код
//           }
        stopLoad()
        if let userInfo = notification.userInfo,
           let error = userInfo["error"] as? NSError,
           let enumValue = userInfo["enumValue"] as? ListenerErrorState {
            showErrorAlert(message: error.localizedDescription, state: self.stateDataSource) {
                switch enumValue {
                    
                case .restartFetchCartProducts:
                    self.homeModel?.restartFetchCartProducts()
                case .restartObserveUser:
                    self.homeModel?.observeUserAndCardProducts()
                }
            }
        }
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
            
        case .firstStart:
            guard let error = error else {
                self.navController?.hiddenPlaceholder()
                self.stateDataSource = .fetchGender
//                self.homeDataSource = data
                return
            }
            self.navController?.showPlaceholder()
            self.showErrorAlert(message: error.localizedDescription, state: self.stateDataSource) {
                self.homeModel?.firstFetchData()
            }
        case .fetchGender:
            <#code#>
        }
       
        
 
//                homeModel?.fetchDataSource(completion: { homeDataSource in
//                    self.stopLoad()
//                    guard let homeDataSource = homeDataSource else {
//
//                        switch self.stateDataSource {
//                        case .firstStart:
//                            self.navController?.showPlaceholder()
//                            self.showErrorAlert(message: "", state: self.stateDataSource) {
//                                self.repeatedFetchData()
//                            }
//                        case .fetchGender:
//                            self.showErrorAlert(message: "", state: self.stateDataSource) {
//                                self.repeatedFetchData()
//                            }
//                        }
//                        return
//                    }
//                    self.navController?.hiddenPlaceholder()
//                    self.stateDataSource = .fetchGender
//                    // при переходе на mallVC, shopVC
//                    self.homeModel?.updateModelGender()
//                    self.homeDataSource = homeDataSource
//                })
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



//// В модели
//func fetchData() {
//    // Попытка получить данные...
//    if let error = error {
//        NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: error)
//    }
//}
//
//// В контроллере
//override func viewDidLoad() {
//    super.viewDidLoad()
//    NotificationCenter.default.addObserver(self, selector: #selector(handleErrorNotification), name: NSNotification.Name("ErrorNotification"), object: nil)
//}
//
//@objc func handleErrorNotification(_ notification: NSNotification) {
//    if let error = notification.object as? Error {
//        // Обработать ошибку и передать ее в представление
//    }
//}

//override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//    NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ErrorNotification"), object: nil)
//}

//@objc func handleErrorNotification(_ notification: NSNotification) {
//    if self.isViewLoaded && self.view.window != nil {
//        // Контроллер видимый, выполняем код
//    }
//}

// all implemintation

//let error = NSError(domain: "domain", code: 123, userInfo: nil)
//let enumValue = YourEnum.someCase
//
//let userInfo: [String: Any] = ["error": error, "enumValue": enumValue]
//NotificationCenter.default.post(name: NSNotification.Name("ErrorNotification"), object: nil, userInfo: userInfo)

//NotificationCenter.default.addObserver(self, selector: #selector(handleErrorNotification(_:)), name: NSNotification.Name("ErrorNotification"), object: nil)
//
//@objc func handleErrorNotification(_ notification: NSNotification) {
//    if let userInfo = notification.userInfo,
//       let error = userInfo["error"] as? NSError,
//       let enumValue = userInfo["enumValue"] as? YourEnum {
//        // Обработать ошибку и значение перечисления
//    }
//}
//            let items = self.createItem(malls: malls, shops: nil, products: nil)
//            let mallSection = SectionModelNew(section: "Malls", items: items)
//
//            guard let _ = self.data?.model?["A"] else {
//                if error == nil, let _ = malls {
//                    self.data?.model?["A"] = mallSection
//                    self.semaphore.signal()
//                } else {
//                    self.caughtError = error
//                    self.semaphore.signal()
//                }
//                return
//            }
//
//            guard let _ = malls, error == nil else {
//                return
//            }
//
//            self.data?.model?["A"] = mallSection

//    func handleErrorAndSignal(_ error: Error) {
//        caughtError = error
//        semaphore.signal()
//    }
//    func handleErrorAndSignal(_ error: Error?) {
//        errors.append(error)
//        semaphore.signal()
//    }

//    func startTimer() {
//
//
//        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
//
//            self.pathsGenderListener.forEach { path in
//                self.bunchData = nil
//                self.group.leave()
//                self.serviceFB.removeListeners(for: path)
//            }
//
//            self.pathsTotalListener.forEach { path in
//                self.group.leave()
//                self.serviceFB.removeListeners(for: path)
//            }
//        }
//    }
//
//    func stopTimer() {
//        timer?.invalidate()
//    }
//func fetchGender() {
//
//
////        caughtError = nil
//        bunchData = BunchData()
//        removeGenderListeners()
//        pathsGenderListener = []
//
//
//
//
//        pathsGenderListener.append("previewMalls\(gender)")
//        previewService.fetchPreviewSection(path: "previewMalls\(gender)") { malls, error in
//            guard let malls = malls, error == nil else {
////                self.handleErrorAndLeaveGroup(error!)
//                return
//            }
//
//            let items = self.createItem(malls: malls, shops: nil, products: nil)
//            let mallSection = SectionModelNew(section: "Malls", items: items)
//
//            guard let _ = self.bunchData?.model?["A"] else {
//                self.bunchData?.model?["A"] = mallSection
//                self.group.leave()
//                return
//            }
//
//            self.group.enter()
//            self.bunchData?.model?["A"] = mallSection
//            self.group.leave()
//        }
//
//        pathsGenderListener.append("previewShops\(gender)")
//        previewService.fetchPreviewSection(path: "previewShops\(gender)") { shops, error in
//
//            guard let shops = shops, error == nil else {
////                self.handleErrorAndLeaveGroup(error!)
//                return
//            }
//
//            let items = self.createItem(malls: nil, shops: shops, products: nil)
//            let shopSection = SectionModelNew(section: "Shops", items: items)
//
//            guard let _ = self.bunchData?.model?["B"] else {
//                self.bunchData?.model?["B"] = shopSection
//                self.group.leave()
//                return
//            }
//
//            self.group.enter()
//            self.bunchData?.model?["B"] = shopSection
//            self.group.leave()
//        }
//
//        pathsGenderListener.append("popularProducts\(gender)")
//        productService.fetchProducts(path: "popularProducts\(gender)") { products, error in
//            guard let products = products, error == nil else {
////                self.handleErrorAndLeaveGroup(error!)
//                return
//            }
//
//            let items = self.createItem(malls: nil, shops: nil, products: products)
//            let productsSection = SectionModelNew(section: "PopularProducts", items: items)
//
//            guard let _ = self.bunchData?.model?["C"] else {
//                self.bunchData?.model?["C"] = productsSection
//                self.group.leave()
//                return
//            }
//            self.group.enter()
//            self.bunchData?.model?["C"] = productsSection
//            self.group.leave()
//        }
//    }
//
//    // а что если в момент fetchGenderData() (нажмем segmentControlVC) сработает наблюдатель в fetchTotalData()
//    func fetchTotalData() {
//
//        removeTotalListener()
//        pathsTotalListener = []
//
//        pathsTotalListener.append("shopsMan")
//        shopsService.fetchShops(path: "shopsMan") { shopsMan, error in
//            guard let shopsMan = shopsMan, error == nil else {
////                self.handleErrorAndLeaveGroup(error!)
//                return
//            }
//            self.serviceFB.shops?["Man"] = shopsMan
//            self.group.leave()
//        }
//
//        pathsTotalListener.append("shopsWoman")
//        shopsService.fetchShops(path: "shopsWoman") { shopsWoman, error in
//            guard let shopsWoman = shopsWoman, error == nil else {
////                self.handleErrorAndLeaveGroup(error!)
//                return
//            }
//            self.serviceFB.shops?["Woman"] = shopsWoman
//            self.group.leave()
//        }
//
//        /// в модель для MapView подготовим в VC
//        pathsTotalListener.append("pinMals")
//        pinService.fetchPin(path: "pinMals") { pins, error in
//            guard let pins = pins, error == nil else {
////                self.handleErrorAndLeaveGroup(error!)
//                return
//            }
//            self.serviceFB.pinMall = pins
//            self.group.leave()
//        }
//    }


// Model

class HomeFirebaseService {
    
    weak var output: HomeModelOutput?
    
    let serviceFB = FirebaseService.shared
    let semaphore = DispatchSemaphore(value: 0)
    
    var pathsGenderListener = [String]()
    var pathsRelatedListener = [String]()
    
    var dataHome:[String:SectionModelNew]? {
        didSet {
            
        }
    }
    var firstErrors: [Error?] = []
    
    var gender:String = ""
    
    let previewService = PreviewCloudFirestoreService()
    let productService = ProductCloudFirestoreService()
    let shopsService = ShopsCloudFirestoreService()
    let pinService = PinCloudFirestoreService()
    
    init(output: HomeModelOutput) {
        self.output = output
        gender = serviceFB.currentGender
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetchFirstDataNotification), name: NSNotification.Name("FetchUserAndCartProductDataNotification"), object: nil)
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
        firstFetchData()
    }
   
    func fetchDataSource() {
        observeUserAndCardProducts()
    }
    
    func firstFetchData() {
        
        DispatchQueue.global().async {
            self.fetchRelatedData()
            self.fetchGenderData()
        }
    }
    
    func fetchGenderData() {
        
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
                self.semaphore.signal()
                return
            }
            
            guard let _ = malls, error == nil else {
                return
            }
            self.dataHome?["A"] = mallSection
        }
        semaphore.wait()
        
        pathsGenderListener.append("previewShops\(gender)")
        previewService.fetchPreviewSection(path: "previewShops\(gender)") { shops, error in
            
            let items = self.createItem(malls: nil, shops: shops, products: nil)
            let shopSection = SectionModelNew(section: "Shops", items: items)
            
            
            guard let _ = self.dataHome?["B"] else {
                
                if let _ = shops, error == nil {
                    self.dataHome?["B"] = shopSection
                }
                self.firstErrors.append(error)
                self.semaphore.signal()
                return
            }
            guard let _ = shops, error == nil else {
                return
            }
            self.dataHome?["B"] = shopSection
        }
        semaphore.wait()
        
        pathsGenderListener.append("popularProducts\(gender)")
        productService.fetchProducts(path: "popularProducts\(gender)") { products, error in
            
            let items = self.createItem(malls: nil, shops: nil, products: products)
            let productsSection = SectionModelNew(section: "PopularProducts", items: items)
            
            
            guard let _ = self.dataHome?["C"] else {
               
                if let _ = products, error == nil {
                    self.dataHome?["C"] = productsSection
                }
                self.firstErrors.append(error)
                self.semaphore.signal()
                return
            }
            
            guard let _ = products, error == nil else {
                return
            }

            self.dataHome?["C"] = productsSection
        }
        semaphore.wait()
        
        DispatchQueue.main.async {
            
            if self.dataHome?.count != 3 {
                self.dataHome = nil
            }
            let firstError = self.firstError(in: self.firstErrors)
            self.firstErrors.removeAll()
            self.output?.updateData(data: self.dataHome, error: firstError)
            guard let _ = firstError else {
                return
            }
            self.deleteAllListeners()
            self.dataHome = nil
            self.serviceFB.shops = nil
            self.serviceFB.pinMall = nil
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
                self.semaphore.signal()
                return
            }
            guard let shopsMan = shopsMan, error == nil else {
                return
            }
            
            self.serviceFB.shops?["Man"] = shopsMan
        }
        semaphore.wait()
        
        pathsRelatedListener.append("shopsWoman")
        shopsService.fetchShops(path: "shopsWoman") { shopsWoman, error in
            
            guard let _ = self.serviceFB.shops?["Woman"] else {
                if let shopsWoman = shopsWoman, error == nil {
                    self.serviceFB.shops?["Woman"] = shopsWoman
                }
                self.firstErrors.append(error)
                self.semaphore.signal()
                return
            }
            guard let shopsWoman = shopsWoman, error == nil else {
                return
            }
            
            self.serviceFB.shops?["Woman"] = shopsWoman
        }
        semaphore.wait()
        
        pathsRelatedListener.append("pinMals")
        pinService.fetchPin(path: "pinMals") { pins, error in
            
            guard let _ = self.serviceFB.pinMall else {
                if let pins = pins, error == nil {
                    self.serviceFB.pinMall = pins
                }
                self.firstErrors.append(error)
                self.semaphore.signal()
                return
            }
            
            guard let pins = pins, error == nil else {
                return
            }
            self.serviceFB.pinMall = pins
        }
        semaphore.wait()
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
                    self.showErrorAlert(message: "", state: self.stateDataSource) {
                        self.catalogModel?.fetchGenderData()
                    }
                case .fetchGender:
                    // можем возвращать из этого места segmentControl на актуальное значение во view
                    self.showErrorAlert(message: "", state: self.stateDataSource) {
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
        previewService.fetchPreviewSection(path: "\(collectionPath)\(gender)") { items, error in
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
