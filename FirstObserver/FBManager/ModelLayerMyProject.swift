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
    let mall: PreviewSectionNew?
    let shop: PreviewSectionNew?
    let popularProduct: ProductItemNew?
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
    var items: [ItemNew]
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
   
    
    
    // MARK: - CloudFirestore
    
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.signInAnonymously()
                }
                return
            }
            self.addEmptyCartProducts(uid: authResult.user.uid)
        }
    }
    
    func addEmptyCartProducts(uid: String) {
        
        let usersCollection = Firestore.firestore().collection("usersAccounts")
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
    
    func listenForUserChangesWithCompletion(completion: @escaping (String) -> Void) {
        userListener { currentUser in
            guard let currentUser = currentUser else {
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
    func fetchCartProducts(completion: @escaping ([ProductItemNew2]?) -> Void)
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
    
    init(output: HomeModelOutput) {
        self.output = output
    }
    
    
}

extension HomeFirebaseService: HomeModelInput {
    
    func fetchBunchData(gender: String, completion: @escaping ([String : SectionModelNew2]) -> Void) {
        <#code#>
    }
    
    
    func fetchCartProducts(completion: @escaping ([ProductItemNew2]?) -> Void) {
        <#code#>
    }
    
}
