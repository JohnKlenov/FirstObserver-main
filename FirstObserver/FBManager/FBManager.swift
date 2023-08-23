//
//  FBManager.swift
//  FirstObserver
//
//  Created by Evgenyi on 20.01.23.
//

import Foundation

import UIKit
//import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseStorageUI
//import FirebaseAnalytics


//(success: Bool)

// experement callBack type



enum AuthResulSignUp {
    case success
    case failure(ErrorSignUp)
}

enum ErrorSignUp {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case wrongPassword
    case somethingWentWrong
}

enum StateDeleteAccaunt {
    case success
    case userNotFound
    case failed
    case failedRequiresRecentLogin
    case networkError
}
enum StateReauthenticateUser {
    case wrongPassword
    case success
    case failed
}

enum ResetProfile {
    case name
    case photoURL
}

enum SignInCallback {
    case success
    case invalidEmail
    case invalidPassword
    case wentWrong
}

// finished callBackTypes

// deleteAccount, signOutAccount, reauthenticateUser

enum StorageErrorCodeState {
    
    case success
    case failed
    case unauthenticated
    case unauthorized
    case retryLimitExceeded
    case downloadSizeExceeded
}

enum AuthErrorCodeState {
    case success
    case failed
    case invalidUserToken
    case userTokenExpired
    case requiresRecentLogin
    case keychainError
    case networkError
    case userNotFound
    case wrongPassword
    case tooManyRequests
    case expiredActionCode
    case invalidCredential
    case invalidRecipientEmail
    case missingEmail
    case invalidEmail
    // Attempt to associate a provider already associated with this account
    case providerAlreadyLinked
    // You are trying to associate credentials that have already been associated with another account
    case credentialAlreadyInUse
    // user account is disabled.
    case userDisabled
    // The email address used for the registration attempt already exists.
    case emailAlreadyInUse
    case weakPassword
}

enum StateCallback {
    case success
    case failed
}

enum StateProfileInfo {
    case success
    case failed(image:Bool? = nil, name:Bool? = nil)
    case nul
}

// в productCell поиграть с приоритетами и >= для constraint
final class FBManager {

    static let shared = FBManager()
    var currentUser: User?
    var cartProducts = [PopularProduct]()
    var avatarRef: StorageReference?
    var refHandleCart: DatabaseHandle?
    var refHandleCatalog: DatabaseHandle?
    var refHandleCategoryProduct: DatabaseHandle?
    var refHandleBrandProduct: DatabaseHandle?
    var refHandleMallModel: DatabaseHandle?
    
    // HVC
    var refHandlePreviewMallsHVC: DatabaseHandle?
    var refHandlePreviewBrandsHVC: DatabaseHandle?
    var refHandlePopularProduct: DatabaseHandle?
    
    // M'sVC
    var refHandlePreviewMallsMVC: DatabaseHandle?
    var refHandlePreviewBrandsMVC: DatabaseHandle?
    
    var removeObserverForUserID: String?
    
    let defaults = UserDefaults.standard
//    let collectorFailedMethods = CollectorFailedMethods.shared
//    var databaseRef: DatabaseReference?
    //
//    lazy var databaseRef = Database.database().reference().child("usersAccaunt/\(currentUser?.uid ?? "")")
//    var databaseRef: DatabaseReference?
//    var storage = Storage.storage()

    
    // MARK: -NetworkConnectivityManager -
    
    func isNetworkConnectivity(completionHandler: @escaping (Bool) -> Void) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
    
    // MARK: - NewProductViewController -
    
    func addProductInBaseData(nameProduct:String, json: Any, callBack: @escaping (StateCallback) -> Void) {
        // если пути нет то он будет создан
        let ref = Database.database().reference(withPath: "usersAccaunt/\(currentUser?.uid ?? "")/AddedProducts")
        ref.updateChildValues([nameProduct : json]) { (error, reference) in
            if error != nil {
                // ошибки которые пользоатель не может решить сам нужно репортить на Crashlytics
                print("Report Crashlytics service")
                callBack(.failed)
            } else {
                callBack(.success)
            }
        }
    }
    
    // MARK: - NewMallViewController -
    
    func removeObserverMallModel(refPath: String) {
        if let refHandle = refHandleMallModel {
//            "MallsMan/\(searchBrand)"
            let gender = defaults.string(forKey: "gender") ?? "Woman"
            let path = "Malls\(gender)"
            Database.database().reference(withPath:"\(path)/\(refPath)").removeObserver(withHandle: refHandle)
        }
    }
    
    func getMallModel(refPath: String, completionHandler: @escaping (MallModel) -> Void) {
        let gender = defaults.string(forKey: "gender") ?? "Woman"
        let path = "Malls\(gender)"
        refHandleMallModel = Database.database().reference().child("\(path)/\(refPath)").observe(.value) { (snapshot) in
//            print("snapshot getMallModel - \(snapshot)")
            var arrayBrands:[String] = []
            var arrayRefImage:[String] = []
            
            for item in snapshot.children {
                let child = item as! DataSnapshot
                
                switch child.key {
                
                case "brands":
                    for itemBrand in child.children {
                        let brand = itemBrand as! DataSnapshot
                        if let nameBrand = brand.value as? String {
                            arrayBrands.append(nameBrand)
                        }
                    }
                case "refImage":
                    for itemRef in child.children {
                        let ref = itemRef as! DataSnapshot
                        if let refImage = ref.value as? String {
                            arrayRefImage.append(refImage)
                        }
                    }
                    
                default:
                    break
                }
                
            }
            let mallModel = MallModel(snapshot: snapshot, refImage: arrayRefImage, brands: arrayBrands)
            completionHandler(mallModel)
        }
    }
    
    // MARK: - CartViewController -
    
    
    func userIsAnonymously(completionHandler: @escaping (Bool) -> Void) {
        guard let user = currentUser else { return }
        if user.isAnonymous {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func removeProduct(refProduct: DatabaseReference) {
        refProduct.removeValue()
//        refProduct.removeValue { (error, reference) in
//            if error != nil {
//                // ошибки которые пользоатель не может решить сам нужно репортить на Crashlytics
//        //        print("Report Crashlytics service")
//            }
//        }
    }
    
    // MARK: - AllProductViewController -
    
    func removeObserverCategoryProduct(path: String) {
        if let refHandle = refHandleCategoryProduct {
            Database.database().reference(withPath: path).removeObserver(withHandle: refHandle)
        }
    }
    
    func getCategoryForBrands(path: String, searchCategory: String, completionHandler: @escaping (PopularGarderob) -> Void) {
        let databaseRef = Database.database().reference(withPath: path)
        refHandleCategoryProduct = databaseRef.observe(.value) { (snapshot) in
            let garderob = PopularGarderob()
            for brand in snapshot.children {
                let brand = brand as! DataSnapshot
                let nameBrand = brand.key
                for categoryBrand in brand.children {
                    let categoryBrand = categoryBrand as! DataSnapshot
                    if categoryBrand.key == searchCategory {
                        let group = PopularGroup(name: nameBrand, group: nil, product: [])
                        for productCategory in categoryBrand.children {
                            let productCategory = productCategory as! DataSnapshot
                            
                            var arrayMalls = [String]()
                            var arrayRefe = [String]()
                            
                            
                            for mass in productCategory.children {
                                let item = mass as! DataSnapshot
                                
                                switch item.key {
                                case "malls":
                                    for it in item.children {
                                        let item = it as! DataSnapshot
                                        if let refDictionary = item.value as? String {
                                            arrayMalls.append(refDictionary)
                                        }
                                    }
                                    
                                case "refImage":
                                    for it in item.children {
                                        let item = it as! DataSnapshot
                                        if let refDictionary = item.value as? String {
                                            arrayRefe.append(refDictionary)
                                        }
                                    }
                                default:
                                    break
                                }
                            }
                            let productModel = PopularProduct(snapshot: productCategory, refArray: arrayRefe, malls: arrayMalls)
                            group.product?.append(productModel)
                        }
                        garderob.groups.append(group)
                    }
                }
            }
            completionHandler(garderob)
        }
    
    }
    
    // MARK: - BrandsViewController -

    func removeObserverBrandProduct(searchBrand: String) {
        if let refHandle = refHandleBrandProduct {
//            "BrandsMan/\(searchBrand)"
            Database.database().reference(withPath:searchBrand).removeObserver(withHandle: refHandle)
        }
    }

    func getBrand(searchBrand: String, completionHandler: @escaping (PopularGarderob) -> Void) {
        //    "BrandsMan/\(searchBrand)"
        let databaseRef = Database.database().reference(withPath:searchBrand)
        refHandleBrandProduct = databaseRef.observe(.value){ (snapshot) in
            
            let garderob = PopularGarderob()
            for item in snapshot.children {
                let itemCategory = item as! DataSnapshot
                let group = PopularGroup(name: itemCategory.key, group: nil, product: [])
                for item in itemCategory.children {
                    let product = item as! DataSnapshot
                    var arrayMalls = [String]()
                    var arrayRefe = [String]()
                    
                    
                    for mass in product.children {
                        let item = mass as! DataSnapshot
                        
                        switch item.key {
                        case "malls":
                            for it in item.children {
                                let item = it as! DataSnapshot
                                if let refDictionary = item.value as? String {
                                    arrayMalls.append(refDictionary)
                                }
                            }
                            
                        case "refImage":
                            for it in item.children {
                                let item = it as! DataSnapshot
                                if let refDictionary = item.value as? String {
                                    arrayRefe.append(refDictionary)
                                }
                            }
                        default:
                            break
                        }
                    }
                    let productModel = PopularProduct(snapshot: product, refArray: arrayRefe, malls: arrayMalls)
                    group.product?.append(productModel)
                }
                garderob.groups.append(group)
            }
            completionHandler(garderob)
        }
    }
    
    
    // MARK: - CatalogViewController -
    
//    func removeObserverCatalog() {
//        if let refHandle = refHandleCatalog {
//            Database.database().reference().child("PreviewCatalogMan").removeObserver(withHandle: refHandle)
//        }
//    }
//    
//    func getPreviewCatalog(completionHandler: @escaping ([PreviewCategory]) -> Void) {
//        refHandleCatalog = Database.database().reference().child("PreviewCatalogMan").observe(.value) { (snapshot) in
//            var arrayCatalog = [PreviewCategory]()
//            for item in snapshot.children {
//                let category = item as! DataSnapshot
//                let model = PreviewCategory(snapshot: category)
//                arrayCatalog.append(model)
//            }
//            completionHandler(arrayCatalog)
//        }
//    }
    
    func removeObserverCatalogGender(path: String) {
        if let refHandle = refHandleCatalog {
            let pathRef = "PreviewCatalog" + path
            Database.database().reference().child(pathRef).removeObserver(withHandle: refHandle)
        }
    }
    
    func getPreviewCatalogGender(path:String, completionHandler: @escaping ([PreviewCategory]) -> Void) {
        let pathRef = "PreviewCatalog" + path
        refHandleCatalog = Database.database().reference().child(pathRef).observe(.value) { (snapshot) in
            var arrayCatalog = [PreviewCategory]()
            for item in snapshot.children {
                let category = item as! DataSnapshot
                let model = PreviewCategory(snapshot: category)
                arrayCatalog.append(model)
            }
            completionHandler(arrayCatalog)
        }
    }
    
    // MARK: - HomeViewController -
    
    func userListener(currentUser: @escaping (User?) -> Void) {

        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
            currentUser(user)
//            print("FBManager func userListener")
        }
    }

    func signInAnonymously() {
        let databaseRef = Database.database().reference()
        Auth.auth().signInAnonymously { (authResult, error) in
            if error != nil {
                print("Returne message for analitic FB Crashlystics")
            }
            guard let user = authResult?.user else {return}
            let uid = user.uid
            databaseRef.child("usersAccaunt/\(uid)").setValue(["uidAnonymous":user.uid])
        }
    }
    
//    func removeObserverForCartProductsUser() {
//        print("func removeObserverForCartProductsUser()")
//        if let refHandle = refHandleCart, let currentUser = currentUser {
////            print("func removeObserverForCartProductsUser()")
//            print("func removeObserverForCartProductsUser()  if let refHandle = refHandleCart, let currentUser = currentUser ")
//            Database.database().reference().child("usersAccaunt/\(currentUser.uid)").removeObserver(withHandle: refHandle)
////            self.refHandle = nil
//        }
//    }
    
    func removeObserverForCartProductsUser() {
        if let refHandle = refHandleCart {
            if let removeObserverForUserID = removeObserverForUserID {
                Database.database().reference().child("usersAccaunt/\(removeObserverForUserID)").removeObserver(withHandle: refHandle)
                self.removeObserverForUserID = nil
            }
//            Database.database().reference().child("usersAccaunt/\(String(describing: currentUser?.uid))").removeObserver(withHandle: refHandle)
//            self.refHandle = nil
        }
    }

    func getCartProduct(completionHandler: @escaping ([PopularProduct]) -> Void) {
        guard let currentUser = currentUser else {
            completionHandler([])
            return
        }
        removeObserverForUserID = currentUser.uid
        refHandleCart = Database.database().reference().child("usersAccaunt/\(currentUser.uid)").observe(.value) { (snapshot) in
            var arrayProduct = [PopularProduct]()
            for item in snapshot.children {
                let item = item as! DataSnapshot
                switch item.key {
                    
                case "AddedProducts":
                    
                    for item in item.children {
                        let product = item as! DataSnapshot

                        var arrayMalls = [String]()
                        var arrayRefe = [String]()


                        for mass in product.children {
                            let item = mass as! DataSnapshot

                            switch item.key {
                            case "malls":
                                for it in item.children {
                                    let item = it as! DataSnapshot
                                    if let refDictionary = item.value as? String {
                                        arrayMalls.append(refDictionary)
                                    }
                                }

                            case "refImage":
                                for it in item.children {
                                    let item = it as! DataSnapshot
                                    if let refDictionary = item.value as? String {
                                        arrayRefe.append(refDictionary)
                                    }
                                }
                            default:
                                break
                            }

                        }
                        let productModel = PopularProduct(snapshot: product, refArray: arrayRefe, malls: arrayMalls)
                        arrayProduct.append(productModel)
                    }
                    completionHandler(arrayProduct)
                default:
                    break
                
                }
            }
            if arrayProduct == [] {
                completionHandler(arrayProduct)
            }
        }
    }
    
    
    // ref.observe(.value) При вызове `getData` без активного подключения к сети, этот метод не будет ожидать восстановления подключения. Вместо этого он сразу вернет ошибку в блоке обработки завершения `completion`.
  // Тут нужно либо подумать о том как это исправить(проблема была в том что при переходе на cartVC из signIn/signUpVC мы неуспевали получить cartProducts в HomeVC и поэтому были вынуждены сделать такой костыль)
    func getCartProductOnce(completionHandler: @escaping ([PopularProduct]) -> Void) {
        guard let currentUser = currentUser else {
            completionHandler([])
            return
        }
        Database.database().reference().child("usersAccaunt/\(currentUser.uid)").getData(completion:  { error, snapshot in
            
            if error != nil {
                print("Returne message for analitic FB Crashlystics")
            }
            
            var arrayProduct = [PopularProduct]()
            if let snapshot = snapshot {
                for item in snapshot.children {
                    let item = item as! DataSnapshot
                    switch item.key {
                        
                    case "AddedProducts":
                        
                        for item in item.children {
                            let product = item as! DataSnapshot

                            var arrayMalls = [String]()
                            var arrayRefe = [String]()


                            for mass in product.children {
                                let item = mass as! DataSnapshot

                                switch item.key {
                                case "malls":
                                    for it in item.children {
                                        let item = it as! DataSnapshot
                                        if let refDictionary = item.value as? String {
                                            arrayMalls.append(refDictionary)
                                        }
                                    }

                                case "refImage":
                                    for it in item.children {
                                        let item = it as! DataSnapshot
                                        if let refDictionary = item.value as? String {
                                            arrayRefe.append(refDictionary)
                                        }
                                    }
                                default:
                                    break
                                }

                            }
                            let productModel = PopularProduct(snapshot: product, refArray: arrayRefe, malls: arrayMalls)
                            arrayProduct.append(productModel)
                        }
                        completionHandler(arrayProduct)
                    default:
                        break
                    
                    }
                }
                if arrayProduct == [] {
                    completionHandler(arrayProduct)
                }
            } else {
                completionHandler(arrayProduct)
            }
        })
    }

    
//    genderHVC
    
    func removeObserverPreviewMallsGenderHVC(path: String) {
        if let refHandle = refHandlePreviewMallsHVC {
            let pathRef = "PreviewMall" + path
            Database.database().reference().child(pathRef).removeObserver(withHandle: refHandle)
        }
    }
    
    func getPreviewMallsGenderHVC(path:String, completionHandler: @escaping ([ItemCell]) -> Void) {
        let pathRef = "PreviewMall" + path
        let databaseRef = Database.database().reference()
        refHandlePreviewMallsHVC = databaseRef.child(pathRef).observe(.value) { snapshot in
            var arrayMalls = [ItemCell]()
            for item in snapshot.children {
                let mall = item as! DataSnapshot
                let modelFB = PreviewCategory(snapshot: mall)
                let modelDataSource = ItemCell(malls: modelFB, brands: nil, popularProduct: nil, mallImage: nil)
                arrayMalls.append(modelDataSource)
            }
            completionHandler(arrayMalls)
        }
    }
    
    func removeObserverPreviewBrandsGenderHVC(path: String) {
        if let refHandle = refHandlePreviewBrandsHVC {
            let pathRef = "PreviewBrand" + path
            Database.database().reference().child(pathRef).removeObserver(withHandle: refHandle)
        }
    }
    
    func getPreviewBrandsGenderHVC(path:String, completionHandler: @escaping ([ItemCell]) -> Void) {
        let pathRef = "PreviewBrand" + path
        let databaseRef = Database.database().reference()
        refHandlePreviewBrandsHVC = databaseRef.child(pathRef).observe(.value) { snapshot in
            var arrayBrands = [ItemCell]()
            for item in snapshot.children {
                let brand = item as! DataSnapshot
//                print("PreviewBrandMan - \(brand)")
                let modelFB = PreviewCategory(snapshot: brand)
                let modelDataSource = ItemCell(malls: nil, brands: modelFB, popularProduct: nil, mallImage: nil)
                arrayBrands.append(modelDataSource)
            }
            completionHandler(arrayBrands)
        }
    }
    
    func removeObserverPopularProductGender(path: String) {
        if let refHandle = refHandlePopularProduct {
            let pathRef = "PopularProduct" + path
            Database.database().reference().child(pathRef).removeObserver(withHandle: refHandle)
        }
    }
    
    func getPopularProductGender(path:String, completionHandler: @escaping ([ItemCell]) -> Void) {
        let pathRef = "PopularProduct" + path
        let databaseRef = Database.database().reference()
        refHandlePopularProduct = databaseRef.child(pathRef).observe(.value) { snapshot in
            var arrayProduct = [ItemCell]()
            
            for item in snapshot.children {
                let product = item as! DataSnapshot
                
                var arrayMalls = [String]()
                var arrayRefe = [String]()
                
                
                for mass in product.children {
                    let item = mass as! DataSnapshot
                    
                    switch item.key {
                    case "malls":
                        for it in item.children {
                            let item = it as! DataSnapshot
                            if let refDictionary = item.value as? String {
                                arrayMalls.append(refDictionary)
                            }
                        }
                        
                    case "refImage":
                        for it in item.children {
                            let item = it as! DataSnapshot
                            if let refDictionary = item.value as? String {
                                arrayRefe.append(refDictionary)
                            }
                        }
                    default:
                        break
                    }
                    
                }
                let modelFB = PopularProduct(snapshot: product, refArray: arrayRefe, malls: arrayMalls)
                let modelDataSource = ItemCell(malls: nil, brands: nil, popularProduct: modelFB, mallImage: nil)
                arrayProduct.append(modelDataSource)
            }
            completionHandler(arrayProduct)
        }
    }
        
    func getPlaces(completionHandler: @escaping ([PlacesFB]) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("Places").observe(.value) { snapshot in
            var arrayPin = [PlacesFB]()
            for place in snapshot.children {
                let place = place as! DataSnapshot
                let model = PlacesFB(snapshot: place)
                arrayPin.append(model)
            }
            completionHandler(arrayPin)
        }
    }
    
    // genderMallsVC
    
    func removeObserverPreviewMallsGenderMVC(path: String) {
        if let refHandle = refHandlePreviewMallsMVC {
            let pathRef = "PreviewMall" + path
            Database.database().reference().child(pathRef).removeObserver(withHandle: refHandle)
        }
    }
    
    func getPreviewMallsGenderMVC(path:String, completionHandler: @escaping ([ItemCell]) -> Void) {
        let pathRef = "PreviewMall" + path
        let databaseRef = Database.database().reference()
        refHandlePreviewMallsMVC = databaseRef.child(pathRef).observe(.value) { snapshot in
            var arrayMalls = [ItemCell]()
            for item in snapshot.children {
                let mall = item as! DataSnapshot
                let modelFB = PreviewCategory(snapshot: mall)
                let modelDataSource = ItemCell(malls: modelFB, brands: nil, popularProduct: nil, mallImage: nil)
                arrayMalls.append(modelDataSource)
            }
            completionHandler(arrayMalls)
        }
    }
    
    func removeObserverPreviewBrandsGenderMVC(path: String) {
        if let refHandle = refHandlePreviewBrandsMVC {
            let pathRef = "PreviewBrand" + path
            Database.database().reference().child(pathRef).removeObserver(withHandle: refHandle)
        }
    }
    
    func getPreviewBrandsGenderMVC(path:String, completionHandler: @escaping ([ItemCell]) -> Void) {
        let pathRef = "PreviewBrand" + path
        let databaseRef = Database.database().reference()
        refHandlePreviewBrandsMVC = databaseRef.child(pathRef).observe(.value) { snapshot in
            var arrayBrands = [ItemCell]()
            for item in snapshot.children {
                let brand = item as! DataSnapshot
//                print("PreviewBrandMan - \(brand)")
                let modelFB = PreviewCategory(snapshot: brand)
                let modelDataSource = ItemCell(malls: nil, brands: modelFB, popularProduct: nil, mallImage: nil)
                arrayBrands.append(modelDataSource)
            }
            completionHandler(arrayBrands)
        }
    }
    
    
    
    
// method not needed 
//    func getImagefromStorage(refImage:String, completionHandler: @escaping (UIImage) -> Void) {
//        let ref = Storage.storage().reference(forURL: refImage)
//        let megaBite = Int64(1*1024*1024)
//        ref.getData(maxSize: megaBite) { (data, error) in
//            guard let imageData = data else {
//                let defaultImage = UIImage(named: "DefaultImage")!
//                completionHandler(defaultImage)
//                return
//            }
//            if let image = UIImage(data: imageData) {
//                completionHandler(image)
//            }
//        }
//    }


    // MARK: - NewProfileViewController -
    
    //  если callback: ((StateProfileInfo, Error?) -> ())? = nil) closure не пометить как @escaping (зачем он нам не обязательный?)
    func updateProfileInfo(withImage image: Data? = nil, name: String? = nil, _ callback: ((StateProfileInfo, Error?) -> ())? = nil) {
        guard let user = currentUser else {
            print("Returne message for analitic FB Crashlystics")
            callback?(.nul, nil)
            return
        }
        
        if let image = image{
            imageChangeRequest(user: user, image: image) { (error) in
                let imageIsFailed = error != nil ? true: false
                self.createProfileChangeRequest(name: name) { (error) in
                    let nameIsFailed = error != nil ? true: false
                    if !imageIsFailed, !nameIsFailed {
                        callback?(.success, error)
                    } else {
                        callback?(.failed(image: imageIsFailed, name: nameIsFailed), error)
                    }
                }
            }
        } else if let name = name {
            self.createProfileChangeRequest(name: name) { error in
                let nameIsFailed = error != nil ? true: false
                if !nameIsFailed {
                    callback?(.success, error)
                } else {
                    callback?(.failed(name: nameIsFailed), error)
                }
            }
        } else {
            // значит что то пошло не так(у нас name = nil, image = nil и при этом сработала save)
            print("Returne message for analitic FB Crashlystics")
            callback?(.nul, nil)
        }
    }
    
    // если callback: ((StateProfileInfo, Error?) -> ())? = nil) closure не пометить как @escaping (зачем он нам не обязательный?)
    func imageChangeRequest(user:User, image:Data,  _ callback: ((Error?) -> ())? = nil) {
        
        let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).jpeg")
        _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
            if let error = error {
                print("не удалось запулить data на сервак")
                callback?(error)
            } else {
                profileImgReference.downloadURL(completion: { (url, error) in
                    if let error = error {
                        self.deleteStorageData(refStorage: profileImgReference)
                        callback?(error)
                    } else if let url = url {
                        self.avatarRef = profileImgReference
                        self.createProfileChangeRequest(photoURL: url) { (error) in
                            if let error = error {
                                self.deleteStorageData(refStorage: profileImgReference)
                                self.avatarRef = nil
                                callback?(error)
                            } else {
                                callback?(error)
                            }
                        }
                    } else {
                        // нужно отловить эту ошибку выше
                        self.deleteStorageData(refStorage: profileImgReference)
                        let userInfo = [NSLocalizedDescriptionKey: "Failed to get avatar link"]
                        let customError = NSError(domain: "Firebase", code: 1001, userInfo: userInfo)
                        callback?(customError)
                    }
                })
            }
        }
    }
    
    func deleteStorageData(refStorage: StorageReference) {
        refStorage.delete { error in
            if error != nil {
                // как я понял это не критично putData перезаписывает файлы с одинаковыми именами и форматом
                print("deleteStorageData Returne message for analitic FB Crashlystics error - \(String(describing: error))")
            }
        }
    }

    
    // если callback: ((StateProfileInfo, Error?) -> ())? = nil) closure не пометить как @escaping (зачем он нам не обязательный?)
    // if error == nil этот callBack не будет вызван(вызов проигнорируется) - callBack: ((Error?) -> Void)? = nil // callBack?(error)
    func createProfileChangeRequest(name: String? = nil, photoURL: URL? = nil,_ callBack: @escaping (Error?) -> Void) {

        if let request = currentUser?.createProfileChangeRequest() {
            if let name = name {
                request.displayName = name
            }

            if let photoURL = photoURL {
                request.photoURL = photoURL
            }

            request.commitChanges { error in
                print("request.commitChanges error - \(String(describing: error)) ")
                    callBack(error)
            }
        }
    }

    // ошибка на давнее не log in ??????
//    ((Error?) -> Void)? = nil
//    func resetProfileChangeRequest(reset: ResetProfile,_ callBack: @escaping (Error?) -> Void) {
//
//        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
//
//            switch reset {
//
//            case .name:
//                request.displayName = nil
//            case .photoURL:
//                request.photoURL = nil
//            }
//            request.commitChanges { error in
//                print("resetProfileChangeRequest - \(String(describing: error))")
////                self.currentUser?.reload()
//                callBack(error)
//            }
//        }
//    }
    
    // сдесь обработка ошибки не актуальна так как вызов метода происходит автоматически после удаления account
    func removeAvatarFromDeletedUser() {
        

        if let avatarRef = avatarRef {
            avatarRef.delete(completion: { error in
                self.avatarRef = nil
                if error != nil {
                    // тут нужно сообщить админу что бы он руками почистил imageAvatar(так как такой id дважды сгенерирован не будет и не перезапишется)
                    print("Returne message for analitic FB Crashlystics")
                }
            })
        }
    }
    
    func removeAvatarFromCurrentUser(_ callback: @escaping (AuthErrorCodeState) -> Void) {
        
        if let avatarRef = avatarRef {
            let url = URL(string: "nil")
            self.createProfileChangeRequest(photoURL: url) { error in
                if let error = error as? AuthErrorCode {
                    switch error.code {
                    case .userTokenExpired:
                        callback(.userTokenExpired)
                    case .invalidUserToken:
                        callback(.invalidUserToken)
                    case .requiresRecentLogin:
                        callback(.requiresRecentLogin)
                    default:
                        callback(.failed)
                    }
                } else {
                    avatarRef.delete(completion: { error in
                        
                        if error != nil {
                            // вызывая `putData` с таким же именем и форматом, то уже существующий файл будет заменен новым файлом по этому если мы с этим id и тем же форматом будем еще раз добавлять image это не страшно
                            print("Returne message for analitic FB Crashlystics")
                        }
                        self.avatarRef = nil
                        callback(.success)
                    })
                }
            }
        } else {
            callback(.failed)
            print("Returne message for analitic FB Crashlystics")
        }
    }
    
    func reloadCurrentUser() {
        Auth.auth().currentUser?.reload() { error in
            if error == nil {
                print("func reloadCurrentUser() success")
            } else {
                print("func reloadCurrentUser() failed")
            }
        }
    }
    


    func cacheImageRemoveMemoryAndDisk(imageView: UIImageView) {
        if let cacheKey = imageView.sd_imageURL?.absoluteString {
            SDImageCache.shared.removeImageFromDisk(forKey: cacheKey)
            SDImageCache.shared.removeImageFromMemory(forKey: cacheKey)
            
            let imageCache = SDImageCache.shared
            // Проверяем наличие изображения в кэше памяти
            let isImageInMemoryCache = imageCache.imageFromMemoryCache(forKey: imageView.sd_imageURL?.absoluteString)
            print("isImageInMemoryCache - \(String(describing: isImageInMemoryCache))")

            // Проверяем наличие изображения в кэше диска
            imageCache.diskImageExists(withKey: imageView.sd_imageURL?.absoluteString) { (isImageInDiskCache) in
                if isImageInDiskCache {
                    print("Изображение есть в кэше диска")
                } else {
                    print("Изображение удалено из кэша диска")
                }
            }

        }
    }

    func updateEmail(to: String, callBack: @escaping (Error?) -> Void) {
        currentUser?.updateEmail(to: to, completion: { (error) in


            if let error = error as? AuthErrorCode {
                switch error.code {
                case .invalidEmail:
                    print("адрес электронной почты имеет неверный формат")
                case .emailAlreadyInUse:
                    print("электронная почта уже используется другой учетной записью")
                case .requiresRecentLogin:
                    print("требуется недавний вход пользователя в систему - reauthenticate(with:)")
                default:
                    print("Try again!")
                }
            }
            callBack(error)
        })
    }
    
    // AuthErrorCodeKeychainError` — Указывает, что произошла ошибка при доступе к цепочке ключей. Поле NSLocalizedFailureReasonErrorKey в словаре userInfo будет содержать дополнительную информацию
//    func signOut(_ callback: (StateCallback, Error?) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            callback(.success, nil)
//        } catch  let error as NSError  {
//
//            print("Auth.auth().signOut() - \(error)")
//            callback(.failed, error)
//        }
//    }
    
//    if let errorAuth = error as? AuthErrorCode
    func signOut(_ callback: @escaping (AuthErrorCodeState) -> Void) {
        do {
            try Auth.auth().signOut()
            callback(.success)
        } catch let error as NSError {
            if let errorAuth = error as? AuthErrorCode {
                switch errorAuth.code {
                case .requiresRecentLogin:
                    callback(.requiresRecentLogin)
                case .userTokenExpired:
                    callback(.requiresRecentLogin)
                case .invalidUserToken:
                    callback(.requiresRecentLogin)
                case .networkError:
                    callback(.networkError)
                case .userNotFound:
                    callback(.userNotFound)
                case .keychainError:
                    callback(.userNotFound)
                default:
                    callback(.failed)
                }
            } else {
                callback(.failed)
            }
            print("Auth.auth().signOut() - \(error)")
        }
    }

    func deleteAccaunt(_ callback: @escaping (AuthErrorCodeState) -> Void) {
        
        guard let user = currentUser else {
            print("Returne message for analitic FB Crashlystics")
            callback(.failed)
            return
        }
        
        user.delete { (error) in
            if let error = error as? AuthErrorCode {
                switch error.code {
                case .requiresRecentLogin:
                    callback(.requiresRecentLogin)
                case .userTokenExpired:
                    callback(.requiresRecentLogin)
                case .invalidUserToken:
                    callback(.requiresRecentLogin)
                case .networkError:
                    callback(.networkError)
                case .userNotFound:
                    callback(.userNotFound)
                case .keychainError:
                    callback(.userNotFound)
                default:
                    print("user.delete error - \(error)")
                    callback(.failed)
                }
            } else {
                self.deleteCartProductsUser(user: user)
                callback(.success)
            }
        }
    }

    func reauthenticateUser(password: String, callback: @escaping (AuthErrorCodeState) -> Void) {
        guard let user = currentUser, let email = user.email else {
            callback(.failed)
            print("Returne message for analitic FB Crashlystics")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { (result, error) in
            
            if let error = error as? AuthErrorCode {
                switch error.code {
                case .wrongPassword:
                    callback(.wrongPassword)
                case .userNotFound:
                    callback(.userNotFound)
                case .invalidCredential:
                    callback(.invalidCredential)
                case .tooManyRequests:
                    callback(.tooManyRequests)
                default:
                    print("func reauthenticateUser error - \(error)")
                    callback(.failed)
                }
            } else {
                callback(.success)
            }
        }
    }

                  
        
    // MARK: - NewSignInViewController -

    
    func signIn(email: String, password: String, callBack: @escaping (AuthErrorCodeState) -> Void) {
        
        guard let currentUser = currentUser else {
            callBack(.failed)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error as? AuthErrorCode {
                
                switch error.code {
                    
                case .invalidEmail:
                    callBack(.invalidEmail)
                case .wrongPassword:
                    callBack(.wrongPassword)
                case .tooManyRequests:
                    callBack(.tooManyRequests)
                case .networkError:
                    callBack(.networkError)
                case .userTokenExpired:
                    callBack(.userTokenExpired)
                case .invalidUserToken:
                    callBack(.invalidUserToken)
                case .requiresRecentLogin:
                    callBack(.requiresRecentLogin)
                case .userDisabled:
                    callBack(.userDisabled)
                default:
                    print("func signIn error - \(error)")
                    callBack(.failed)
                }
            } else {
                if currentUser.isAnonymous {
                    currentUser.delete { error in
                        if let error = error {
                            print("Returne message for analitic FB Crashlystics error - \(error.localizedDescription) ")
                        }
                    }
                    self.deleteCartProductsUser(user: currentUser)
                }
                callBack(.success)
            }
        }
    }
    
    private func deleteCartProductsUser(user: User) {
        let uidUser = user.uid
        let canDelete: [String:Bool] = [uidUser:true]
        let ref = Database.database().reference().child("usersAccaunt").child(uidUser)
        ref.updateChildValues(canDelete) { (error, ref) in
            if error == nil {
                Database.database().reference().child("usersAccaunt").child(uidUser).removeValue { (error, reference) in
                    if let error = error {
                        // не удалось удалить CartProductsUser
                        print("Returne message for analitic FB Crashlystics Error - \(error.localizedDescription)")
                    }
                }
            } else {
                // не удалось удалить CartProductsUser
                print("Returne message for analitic FB Crashlystics Error - \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
    
    func sendPasswordReset(email: String, _ callBack: @escaping (AuthErrorCodeState) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
           
            if let error = error as? AuthErrorCode {
                switch error.code {
                case .userTokenExpired:
                    callBack(.userTokenExpired)
                case .invalidUserToken:
                    callBack(.invalidUserToken)
                case .requiresRecentLogin:
                    callBack(.requiresRecentLogin)
                case .tooManyRequests:
                    callBack(.tooManyRequests)
                case .invalidRecipientEmail:
                    callBack(.invalidRecipientEmail)
                case .missingEmail:
                    callBack(.missingEmail)
                case .invalidEmail:
                    callBack(.invalidEmail)
                default:
                    callBack(.failed)
                }
            } else {
                callBack(.success)
            }
        }
    }
    
    // MARK: - NewSignUpViewController
    
    // ловить ошибку тут нет резона так как при сохранении продукта мы создадим путь только будет без ["uidPermanent":user.uid]
    func updateRefPathForUserAccount(user: User) {
        let uid = user.uid
        let refFBR = Database.database().reference()
        refFBR.child("usersAccaunt/\(uid)").updateChildValues(["uidPermanent":user.uid])
        refFBR.child("usersAccaunt/\(uid)/uidAnonymous").setValue(nil)
    }
    
    func registerUserSignUpVC(email: String, password: String, name: String, callBack: @escaping (AuthErrorCodeState) -> Void) {
        
        guard let currentUser = currentUser else {
            callBack(.failed)
            return
        }
        
        if currentUser.isAnonymous {
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            currentUser.link(with: credential) { [weak self] (result, error) in
                
                if let error = error as? AuthErrorCode {
                    
                    switch error.code {
                        
                    case .providerAlreadyLinked:
                        callBack(.providerAlreadyLinked)
                    case .credentialAlreadyInUse:
                        callBack(.credentialAlreadyInUse)
                    case .tooManyRequests:
                        callBack(.tooManyRequests)
                    case .userTokenExpired:
                        callBack(.userTokenExpired)
                    case .invalidUserToken:
                        callBack(.invalidUserToken)
                    case .requiresRecentLogin:
                        callBack(.requiresRecentLogin)
                    case .emailAlreadyInUse:
                        callBack(.emailAlreadyInUse)
                    case .invalidEmail:
                        callBack(.invalidEmail)
                    case .weakPassword:
                        callBack(.weakPassword)
                    case .networkError:
                        callBack(.networkError)
                    default:
                        callBack(.failed)
                    }
                } else {
                    if let error = error {
                        print("Returne message for analitic FB Crashlystics error - \(String(describing: error))")
                        callBack(.failed)
                    } else {
                        self?.createProfileChangeRequest(name: name, { error in
                            if error != nil {
                                print("Returne message for analitic FB Crashlystics error - \(String(describing: error))")
                            }
                            self?.verificationEmailSignUp()
                            if let user = result?.user {
                                self?.updateRefPathForUserAccount(user: user)
                                self?.currentUser = user
                            } else {
                                Auth.auth().currentUser?.reload(completion: { [weak self] error in
                                    if let user = Auth.auth().currentUser {
                                        self?.updateRefPathForUserAccount(user: user)
                                        self?.currentUser = user
                                    } else {
                                        print("Returne message for analitic FB Crashlystics error - \(String(describing: error))")
                                    }
                                })
                            }
                            callBack(.success)
                        })
                    }
                }
            }
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                
                if let error = error as? AuthErrorCode {
                    
                    switch error.code {
                    case .invalidEmail:
                        callBack(.invalidEmail)
                    case .emailAlreadyInUse:
                        callBack(.emailAlreadyInUse)
                    case .weakPassword:
                        callBack(.weakPassword)
                    case .requiresRecentLogin:
                        callBack(.requiresRecentLogin)
                    case .userTokenExpired:
                        callBack(.userTokenExpired)
                    case .invalidUserToken:
                        callBack(.invalidUserToken)
                    case .networkError:
                        callBack(.networkError)
                    case .tooManyRequests:
                        callBack(.tooManyRequests)
                    default:
                        callBack(.failed)
                        
                    }
                } else {
                    if let error = error {
                        print("Returne message for analitic FB Crashlystics error - \(String(describing: error))")
                        callBack(.failed)
                    } else {
                        self?.createProfileChangeRequest(name: name, { error in
                            if error != nil {
                                print("Returne message for analitic FB Crashlystics error - \(String(describing: error))")
                            }
                            if let user = result?.user {
                                self?.updateRefPathForUserAccount(user: user)
                            } else {
                                print("Returne message for analitic FB Crashlystics error")
                            }
                            self?.verificationEmailSignUp()
                            callBack(.success)
                        })
                    }
                }
            }
        }
    }
    
    // Отправить пользователю электронное письмо с подтверждением регистрации
    func verificationEmailSignUp() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                print("Returne message for analitic FB Crashlystics error - \(String(describing: error))")
            }
        })
    }
}


extension UIImageView {

    func fetchingImageWithPlaceholder(url: String, defaultImage: UIImage?) {
        let storage = Storage.storage()
        let urlRef = storage.reference(forURL: url)
        self.sd_setImage(with: urlRef, maxImageSize: 1024*1024, placeholderImage: defaultImage, options: .refreshCached) { (image, error, cashType, storageRef) in
//            print(" func fetchingImageWithPlaceholder - storageRef - \(storageRef)")
            FBManager.shared.avatarRef = storageRef
            if error != nil {
                self.image = defaultImage
            }
        }
    }
}




// MARK: - Cloud Firestore API -

//Ваша структура данных в Firebase Firestore выглядит следующим образом:
//
//```
//- Magazines (коллекция)
//    - Zara (документ)
//        - ZaraMagazines (коллекция)
//            - ZaraGreenCity (документ)
//                - объект
//        - ZaraDanaMall (документ)
//            - объект
//    - LCWikiki (документ)
//        - LCWikikiMagazines (коллекция)
//            - LCWikikiPalazzo (документ)
//                - объект
//- NikeZamok (документ)
//    - NikeZamokMagazines (коллекция)
//        - NikeZamok (документ)
//            - объект
//```


//struct Shop {
//    var name:String?
//    var mall:String?
//    var floor:String?
//    var refImage:String?
//    var telefon:String?
//    var webSite:String?
//}
//
//struct ProductItem {
//    let brand: String?
//    let model: String?
//    let category: String?
//    let popularityIndex: Int?
//    let strengthIndex: Int?
//    let type: String?
//    let description: String?
//    let price: Int?
//    let refImage: [String]?
//    let shops: [String]?
//    let originalContent: String?
//}

enum AppErrorCode: Int {
    case fetchDocumentsError = 1
    // Добавьте другие коды ошибок, если необходимо
}


class ManagerFB {
    
    static let shared = ManagerFB()
    var currentUser:User?
    let firestore = Firestore.firestore()
    var listenerFetchShops: ListenerRegistration?
    var listenerFetchProductsMan: ListenerRegistration?
    var listenerFetchPreviewShops: ListenerRegistration?
    var listenerFetchPreviewMalls: ListenerRegistration?
    var listenerFetchPopularProducts: ListenerRegistration?
    var listenerFetchCartProducts: ListenerRegistration?
    var removeListenerForUserID: String?
    var listenerFetchPinMalls: ListenerRegistration?
    
    // test
    var listenerFetchShopsMan: ListenerRegistration?
    var listenerFetchShopsWoman: ListenerRegistration?
    
    // MallVC
    var listenerFetchMall: ListenerRegistration?
    
    // ShopProductsVC
    var listenerFetchShopProducts: ListenerRegistration?
    
    var cartProducts: [ProductItem] = []
    
    // MARK: - HomeVC -
    
    // если будет изменение данных по ref и при этом ошибка не удалять уже имеющийся маасив с продуктами на VC

    // тут нужно поработать над гарантией создания анонимного, ведь без него мы не сможем загрузить все данные -> у нас всегда будет try agayne!
    //    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    //                    signInAnonymously()
    //                }
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.addEmptyCartProducts(uid: uid)
                }
            }
        }
    }
    
    func removeListenerFetchShopsMan() {
        if let listenerFetchShops = listenerFetchShopsMan {
            listenerFetchShops.remove()
        }
    }
    
    func removeListenerFetchShopsWoman() {
        if let listenerFetchShops = listenerFetchShopsWoman {
            listenerFetchShops.remove()
        }
    }
    
    func fetchShopsWoman(completion: @escaping ([Shop]?, Error?) -> Void) {
        let path = "shopsWoman"
        let firestore = Firestore.firestore()
        let shopsCollection = firestore.collection(path)

        listenerFetchShopsWoman = shopsCollection.addSnapshotListener { querySnapshot, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }

            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            var shops: [Shop] = []
            var currentErrors: [Error] = []
            let dispatchGroup = DispatchGroup()

            for document in querySnapshot.documents {
//                let documentData = document.data()

                dispatchGroup.enter()

                let productsCollectionRef = document.reference.collection("allShops")

                productsCollectionRef.getDocuments { (subquerySnapshot, error) in

                    guard error == nil else {
                        currentErrors.append(error!)
                        dispatchGroup.leave()
                        return
                    }

                    guard let subdocuments = subquerySnapshot?.documents else {
                        dispatchGroup.leave()
                        return
                    }

                    for subdocument in subdocuments {
                        let subDocumentData = subdocument.data()

                        // Работа с каждым поддокументом из подколлекции
                        let name = subDocumentData["name"] as? String
                        let mall = subDocumentData["mall"] as? String
                        let floor = subDocumentData["floor"] as? String
                        let refImage = subDocumentData["refImage"] as? String
                        let telefon = subDocumentData["telefon"] as? String
                        let webSite = subDocumentData["webSite"] as? String

                        let magazine = Shop(name: name, mall: mall, floor: floor, refImage: refImage, telefon: telefon, webSite: webSite)

                        shops.append(magazine)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                if currentErrors.isEmpty {
                    completion(shops, nil)
                } else {
                    print("Returned message for analytic FB Crashlytics error")
                    completion(shops, currentErrors.first)
                }
            }
        }
    }
    
    func fetchShopsMan(completion: @escaping ([Shop]?, Error?) -> Void) {
        let path = "shopsMan"
        let firestore = Firestore.firestore()
        let shopsCollection = firestore.collection(path)

        listenerFetchShopsMan = shopsCollection.addSnapshotListener { querySnapshot, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }

            var shops: [Shop] = []
            var currentErrors: [Error] = []
            let dispatchGroup = DispatchGroup()

            for document in querySnapshot.documents {
//                let documentData = document.data()

                dispatchGroup.enter()

                let productsCollectionRef = document.reference.collection("allShops")

                productsCollectionRef.getDocuments { (subquerySnapshot, error) in

                    guard error == nil else {
                        currentErrors.append(error!)
                        dispatchGroup.leave()
                        return
                    }

                    guard let subdocuments = subquerySnapshot?.documents else {
                        dispatchGroup.leave()
                        return
                    }

                    for subdocument in subdocuments {
                        let subDocumentData = subdocument.data()

                        // Работа с каждым поддокументом из подколлекции
                        let name = subDocumentData["name"] as? String
                        let mall = subDocumentData["mall"] as? String
                        let floor = subDocumentData["floor"] as? String
                        let refImage = subDocumentData["refImage"] as? String
                        let telefon = subDocumentData["telefon"] as? String
                        let webSite = subDocumentData["webSite"] as? String

                        let magazine = Shop(name: name, mall: mall, floor: floor, refImage: refImage, telefon: telefon, webSite: webSite)

                        shops.append(magazine)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                if currentErrors.isEmpty {
                    completion(shops, nil)
                } else {
                    print("Returned message for analytic FB Crashlytics error")
                    completion(shops, currentErrors.first)
                }
            }
        }
    }
    
    func removeListenerFetchPreviewShops() {
        if let listenerFetchPreviewShops = listenerFetchPreviewShops {
            listenerFetchPreviewShops.remove()
        }
    }
    
    func fetchPreviewShops(gender: String, completion: @escaping ([Item]?, Error?) -> Void) {
        let path = "previewShops" + gender
        let firestore = Firestore.firestore()
        let shopsCollection = firestore.collection(path)
        let quary = shopsCollection.order(by: "number", descending: false)
        
        listenerFetchPreviewShops = quary.addSnapshotListener { (querySnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            var items = [Item]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                
                let shop = documentData["shop"] as? String
                let refImage = documentData["refImage"] as? String
                let model = PreviewSection(name: shop, refImage: refImage, floor: nil)
                let item = Item(mall: nil, shop: model, popularProduct: nil)
                items.append(item)
            }
            completion(items, nil)
        }
    }
    
    func removeListenerFetchPreviewMalls() {
        if let listenerFetchPreviewMalls = listenerFetchPreviewMalls {
            listenerFetchPreviewMalls.remove()
        }
    }
    
    func fetchPreviewMalls(gender: String, completion: @escaping ([Item]?, Error?) -> Void) {
        
        let path = "previewMalls" + gender
        let firestore = Firestore.firestore()
        let mallsCollection = firestore.collection(path)
        let quary = mallsCollection.order(by: "number", descending: false)
        
        listenerFetchPreviewMalls = quary.addSnapshotListener { (querySnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            var items = [Item]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                
                let shop = documentData["mall"] as? String
                let refImage = documentData["refImage"] as? String
                let model = PreviewSection(name: shop, refImage: refImage, floor: nil)
                let item = Item(mall: model, shop: nil, popularProduct: nil)
                items.append(item)
            }
            completion(items, nil)
        }
    }
    
    func removeListenerFetchPopularProducts() {
        if let listenerFetchPopularProducts = listenerFetchPopularProducts {
            listenerFetchPopularProducts.remove()
        }
    }
    
    func fetchPopularProducts(gender: String, completion: @escaping ([Item]?, Error?) -> Void) {
        
        let path = "popularProducts" + gender
        let firestore = Firestore.firestore()
        let popularProductsCollection = firestore.collection(path)
        
        listenerFetchPopularProducts = popularProductsCollection.addSnapshotListener { (querySnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            var items = [Item]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                
                let brand = documentData["brand"] as? String
                let modelProduct = documentData["model"] as? String
                let category = documentData["category"] as? String
                let popularityIndex = documentData["popularityIndex"] as? Int
                let strengthIndex = documentData["strengthIndex"] as? Int
                let type = documentData["type"] as? String
                let description = documentData["description"] as? String
                let price = documentData["price"] as? Int
                let refImage = documentData["refImage"] as? [String]
                let shops = documentData["shops"] as? [String]
                let originalContent = documentData["originalContent"] as? String
                let model = ProductItem(brand: brand, model: modelProduct, category: category, popularityIndex: popularityIndex, strengthIndex: strengthIndex, type: type, description: description, price: price, refImage: refImage, shops: shops, originalContent: originalContent)
                let item = Item(mall: nil, shop: nil, popularProduct: model)
                items.append(item)
            }
            completion(items, nil)
        }
    }
    
    func removeListenerFetchCartProducts() {
        if let listenerFetchCartProducts = listenerFetchCartProducts {
            if let _ = removeListenerForUserID {
                listenerFetchCartProducts.remove()
                self.removeListenerForUserID = nil
            }
            
        }
    }

    //            guard let documents = querySnapshot?.documents else {
    //                completion([], error)
    //                return
    //            }
    func fetchCartProducts(completion: @escaping ([ProductItem]?, Error?) -> Void) {
        
        guard let currentUser = currentUser else {
            completion(nil, nil)
            return
        }
        
//        removeListenerForUserID = currentUser.uid
        let firestore = Firestore.firestore()
        let cartProductsCollection = firestore.collection("usersAccounts").document(currentUser.uid).collection("cartProducts")
        
        listenerFetchCartProducts = cartProductsCollection.addSnapshotListener { (querySnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion([], error)
                return
            }

            let documents = querySnapshot.documents
            var cartProducts = [ProductItem]()
            
            for document in documents {
                let documentData = document.data()
                
                let brand = documentData["brand"] as? String
                let modelProduct = documentData["model"] as? String
                let category = documentData["category"] as? String
                let popularityIndex = documentData["popularityIndex"] as? Int
                let strengthIndex = documentData["strengthIndex"] as? Int
                let type = documentData["type"] as? String
                let description = documentData["description"] as? String
                let price = documentData["price"] as? Int
                let refImage = documentData["refImage"] as? [String]
                let shops = documentData["shops"] as? [String]
                let originalContent = documentData["originalContent"] as? String
                let model = ProductItem(brand: brand, model: modelProduct, category: category, popularityIndex: popularityIndex, strengthIndex: strengthIndex, type: type, description: description, price: price, refImage: refImage, shops: shops, originalContent: originalContent)
                cartProducts.append(model)
            }
            completion(cartProducts, nil)
        }
    }
    
    func removeListenerFetchPinMalls() {
        if let listenerFetchPinMalls = listenerFetchPinMalls {
            listenerFetchPinMalls.remove()
        }
    }
    
    func fetchPinMalls(completion: @escaping ([PinMallsFB]?, Error?) -> Void) {
        
        let firestore = Firestore.firestore()
        let pinCollection = firestore.collection("pinMalls")
        
        listenerFetchPinMalls = pinCollection.addSnapshotListener { (querySnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            var items = [PinMallsFB]()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                
                let mall = documentData["mall"] as? String
                let address = documentData["address"] as? String
                let refImage = documentData["refImage"] as? String
                let latitude = documentData["latitude"] as? Double
                let longitude = documentData["longitude"] as? Double
                let pinMall = PinMallsFB(mall: mall, refImage: refImage, address: address, latitude: latitude, longitude: longitude)
                items.append(pinMall)
            }
            completion(items, nil)
        }
    }
    
    
    // MARK: - MallVC -
    
    func removeListenerFetchMall() {
        if let listenerFetchMall = listenerFetchMall {
            listenerFetchMall.remove()
        }
    }
    
    func fetchMall(gender: String, path: String, completion: @escaping (MallItem?, Error?) -> Void) {
        
        let firestore = Firestore.firestore()
        let mallDocument = firestore.collection("malls\(gender)").document(path)
        listenerFetchMall = mallDocument.addSnapshotListener { (documentSnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let document = documentSnapshot else {
                completion(nil, error)
                return
            }
            
            if document.exists {
                let data = document.data()
                
                if let data = data {
                    let name = data["name"] as? String
                    let description = data["description"] as? String
                    let floorPlan = data["floorPlan"] as? String
                    let webSite = data["webSite"] as? String
                    let refImage = data["refImage"] as? [String]
                    let mall = MallItem(name: name, description: description, floorPlan: floorPlan, refImage: refImage, webSite: webSite)
                    completion(mall,error)
                }
            } else {
                // Документ не найден
                completion(nil, error)
            }
        }
    }
    
    
    // MARK: - ShopProdutctsVC -
    
    func removeListenerFetchShopProducts() {
        if let listenerFetchShopProducts = listenerFetchShopProducts {
            listenerFetchShopProducts.remove()
        }
    }
    
    func fetchShopProdutcts(gender: String, path: String, completion: @escaping ([ProductItem]?, Error?) -> Void) {
        let firestore = Firestore.firestore()
        let productsRef = firestore.collection("products\(gender)").document(path).collection("products")
        
        listenerFetchShopProducts = productsRef.addSnapshotListener { (querySnapshot, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            let documents = querySnapshot.documents
            var productsShop = [ProductItem]()
            
            for document in documents {
                let product = document.data()
                
                let brand = product["brand"] as? String
                let model = product["model"] as? String
                let category = product["category"] as? String
                let popularityIndex = product["popularityIndex"] as? Int
                let strengthIndex = product["strengthIndex"] as? Int
                let type = product["type"] as? String
                let description = product["description"] as? String
                let price = product["price"] as? Int
                let originalContent = product["originalContent"] as? String
                let refImage = product["refImage"] as? [String]
                let shops = product["shops"] as? [String]

                let productItem = ProductItem(brand: brand, model: model, category: category, popularityIndex: popularityIndex, strengthIndex: strengthIndex, type: type, description: description, price: price, refImage: refImage, shops: shops, originalContent: originalContent)

                productsShop.append(productItem)
            }
            completion(productsShop, error)
        }
    }
    
    
    // MARK: - CatalogVC -
   
    func removeListenerFetchProducts() {
        if let listenerFetchProductsMan = listenerFetchProductsMan {
            listenerFetchProductsMan.remove()
        }
    }
    
    // у нас есть в циклах обращения к API CloudFirestore что увеличивает появление bugs
    // может проще бы было не содавать доументы внутри коллекции productsMan
    // а просто иметь document -> products
    // получать из него снимок а потом в оперативной памяти сделать сортировку?
    
    // Запрос для сортировки документов по полю indexPopularity в порядке убывания
    // let query = productsRef.order(by: "indexPopularity", descending: true)
    
    // такой вариант более правельный нежели
    //  guard let documents = querySnapshot?.documents else ведь documents = [ ]
    
    func fetchProducts(gender: String, completion: @escaping (CatalogProducts?, Error?) -> Void) {
        let path = "products" + gender
        let db = Firestore.firestore()
        let productsManCollection = db.collection(path)
        
        // Получение всех документов из коллекции "productsMan"
        listenerFetchProductsMan = productsManCollection.addSnapshotListener { (querySnapshot, error) in
          
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil, error)
                return
            }
            
            let productsForCatalog = CatalogProducts()
            let allCategory = CategoryProducts(name: "All", product: [])
            productsForCatalog.categorys.append(allCategory)
            var categoryProductsDict: [String: [ProductItem]] = [:]
            
            let dispatchGroup = DispatchGroup()
            
            for document in querySnapshot.documents {
                
                let brandShop = document.documentID
                
                dispatchGroup.enter()
                
                let productsRef = db.collection("products\(gender)").document(brandShop).collection("products")
                
                productsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Ошибка при получении документов: \(error)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("Документы не найдены")
                        dispatchGroup.leave()
                        return
                    }

                    for document in documents {
                        // Обрабатываем каждый документ здесь
                        let product = document.data()
                        print("product - \(product)")
                        
                        let brand = product["brand"] as? String
                        let model = product["model"] as? String
                        let category = product["category"] as? String
                        let popularityIndex = product["popularityIndex"] as? Int
                        let strengthIndex = product["strengthIndex"] as? Int
                        let type = product["type"] as? String
                        let description = product["description"] as? String
                        let price = product["price"] as? Int
                        let originalContent = product["originalContent"] as? String
                        let refImage = product["refImage"] as? [String]
                        let shops = product["shops"] as? [String]
                        
                        let productItem = ProductItem(brand: brand, model: model, category: category, popularityIndex: popularityIndex, strengthIndex: strengthIndex, type: type, description: description, price: price, refImage: refImage, shops: shops, originalContent: originalContent)
                        
                        if let category = productItem.category {
                            if categoryProductsDict[category] != nil {
                                categoryProductsDict[category]?.append(productItem)
                            } else {
                                categoryProductsDict[category] = [productItem]
                            }
                        }
                        allCategory.product?.append(productItem)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                
                for (category, products) in categoryProductsDict {
                    let categoryProduct = CategoryProducts(name: category, product: products)
                    productsForCatalog.categorys.append(categoryProduct)
                }
                
                for category in productsForCatalog.categorys {
                    
                    guard let products = category.product else { continue }
                    let sortedProducts = products.sorted(by: { $0.popularityIndex ?? 0 > $1.popularityIndex ?? 0 })
                    category.product = sortedProducts
                }
                completion(productsForCatalog, error)
            }
        }
    }
    
    
    // MARK: - ProductVC -
    
    func addProductFB(documentID:String, product: [String:Any], completion:  @escaping (StateCallback) -> Void) {
        let db = Firestore.firestore()
        let productsRef = db.collection("usersAccount").document("currentUser?.uid").collection("addedProducts").document(documentID)
        productsRef.setData(product) { error in
            if let error = error {
                  print("Ошибка при добавлении документа: \(error.localizedDescription)")
                completion(.failed)
              } else {
                  print("Документ успешно добавлен")
                  completion(.success)
              }
        }
    }
}




//    func fetchProducts(gender: String, completion: @escaping (CatalogProducts?, Error?) -> Void) {
//        let path = "products" + gender
//        let db = Firestore.firestore()
//        let productsManCollection = db.collection(path)
//
//        // Получение всех документов из коллекции "productsMan"
//        listenerFetchProductsMan = productsManCollection.addSnapshotListener { (querySnapshot, error) in
//
//            guard error == nil else {
//                completion(nil, error)
//                return
//            }
//
//            // такой вариант более правельный нежели
//            //  guard let documents = querySnapshot?.documents else ведь documents = [ ]
//            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
//                completion(nil, error)
//                return
//            }
//
//
//
//            let productsForCatalog = CatalogProducts()
//            let allCategory = CategoryProducts(name: "All", product: [])
//            productsForCatalog.categorys.append(allCategory)
////            var categoryProductsDict: [String: [ProductItem]] = [:]
//            let dispatchGroup = DispatchGroup()
//
//            for document in querySnapshot.documents {
//
//                let brandShop = document.documentID
//
//                dispatchGroup.enter()
//
//                let productsRef = db.collection("products\(gender)").document(brandShop).collection("products")
//
//                // Запрос для сортировки документов по полю indexPopularity в порядке убывания
//                //                let query = productsRef.order(by: "indexPopularity", descending: true)
//
//                productsRef.getDocuments { (snapshot, error) in
//                    if let error = error {
//                        print("Ошибка при получении документов: \(error)")
//                        dispatchGroup.leave()
//                        return
//                    }
//
//                    guard let documents = snapshot?.documents else {
//                        print("Документы не найдены")
//                        dispatchGroup.leave()
//                        return
//                    }
//                    var categoryProductsDict: [String: [ProductItem]] = [:]
//
//                    for document in documents {
//                        // Обрабатываем каждый документ здесь
//                        let product = document.data()
//                        print("product - \(product)")
//
//                        let brand = product["brand"] as? String
//                        let model = product["model"] as? String
//                        let category = product["category"] as? String
//                        let popularityIndex = product["popularityIndex"] as? Int
//                        let strengthIndex = product["strengthIndex"] as? Int
//                        let type = product["type"] as? String
//                        let description = product["description"] as? String
//                        let price = product["price"] as? Int
//                        let originalContent = product["originalContent"] as? String
//                        let refImage = product["refImage"] as? [String]
//                        let shops = product["shops"] as? [String]
//
//                        let productItem = ProductItem(brand: brand, model: model, category: category, popularityIndex: popularityIndex, strengthIndex: strengthIndex, type: type, description: description, price: price, refImage: refImage, shops: shops, originalContent: originalContent)
//
//                        if let category = productItem.category {
//                            if categoryProductsDict[category] != nil {
//                                categoryProductsDict[category]?.append(productItem)
//                            } else {
//                                categoryProductsDict[category] = [productItem]
//                            }
//                        }
//                        allCategory.product?.append(productItem)
//                    }
//
//                    for (category, products) in categoryProductsDict {
//                        let categoryProduct = CategoryProducts(name: category, product: products)
//                        productsForCatalog.categorys.append(categoryProduct)
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//            dispatchGroup.notify(queue: .main) {
//
//                for category in productsForCatalog.categorys {
//
//                    guard let products = category.product else { continue }
//                    let sortedProducts = products.sorted(by: { $0.popularityIndex ?? 0 > $1.popularityIndex ?? 0 })
//                    category.product = sortedProducts
//                }
//                completion(productsForCatalog, error)
//            }
//        }
//    }

//    func removeListenerFetchShops() {
//        if let listenerFetchShops = listenerFetchShops {
//            listenerFetchShops.remove()
//        }
//    }

//    func fetchShops(gender: String, completion: @escaping ([Shop]?, Error?) -> Void) {
//        let path = "shops" + gender
//        let firestore = Firestore.firestore()
//        let shopsCollection = firestore.collection(path)
//
//        listenerFetchShops = shopsCollection.addSnapshotListener { querySnapshot, error in
//
//            guard error == nil else {
//                completion(nil, error)
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                completion(nil, error)
//                return
//            }
//
//            var shops: [Shop] = []
//            var currentErrors: [Error] = []
//            let dispatchGroup = DispatchGroup()
//
//            for document in documents {
////                let documentData = document.data()
//
//                dispatchGroup.enter()
//
//                let productsCollectionRef = document.reference.collection("allShops")
//
//                productsCollectionRef.getDocuments { [weak self] (subquerySnapshot, error) in
//
//                    guard error == nil else {
//                        currentErrors.append(error!)
//                        dispatchGroup.leave()
//                        return
//                    }
//
//                    guard let subdocuments = subquerySnapshot?.documents else {
//                        dispatchGroup.leave()
//                        return
//                    }
//
//                    for subdocument in subdocuments {
//                        let subDocumentData = subdocument.data()
//
//                        // Работа с каждым поддокументом из подколлекции
//                        let name = subDocumentData["name"] as? String
//                        let mall = subDocumentData["mall"] as? String
//                        let floor = subDocumentData["floor"] as? String
//                        let refImage = subDocumentData["refImage"] as? String
//                        let telefon = subDocumentData["telefon"] as? String
//                        let webSite = subDocumentData["webSite"] as? String
//
//                        let magazine = Shop(name: name, mall: mall, floor: floor, refImage: refImage, telefon: telefon, webSite: webSite)
//
//                        shops.append(magazine)
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//
//            dispatchGroup.notify(queue: .main) {
//                if currentErrors.isEmpty {
//                    completion(shops, nil)
//                } else {
//                    print("Returned message for analytic FB Crashlytics error")
//                    completion(shops, currentErrors.first)
//                }
//            }
//        }
//    }

//func fetchShops(gender: String, completion: @escaping ([Shop]?, Error?) -> Void) {
//        let path = "shops" + gender
//        let firestore = Firestore.firestore()
//        let shopsCollection = firestore.collection(path)
//
//        listenerFetchShops = shopsCollection.addSnapshotListener { querySnapshot, error in
//
//            guard error == nil else {
//                completion([Shop](), error)
//                return
//            }
//            // Если documents == nil, значит нет документов для обработки.
//            guard let documents = querySnapshot?.documents else {
//                completion([Shop](), error)
//                return
//            }
//
//            var shops: [Shop] = []
//            var currentErrors: [NSError] = []
//            let dispatchGroup = DispatchGroup()
//
//            for document in documents {
//                // Enter dispatch group before async call
//                dispatchGroup.enter()
//                // Get products subcollection reference
//                let productsCollectionRef = document.reference.collection("allShops")
//
//
//                productsCollectionRef.getDocuments { (subquerySnapshot, error) in
//
//                    let userInfo = [NSLocalizedDescriptionKey: "Error fetchShops for allShops - \(String(describing: error?.localizedDescription))"]
//                    let customError = NSError(domain: "CloudFirestore", code: AppErrorCode.fetchDocumentsError.rawValue, userInfo: userInfo)
//
//                    guard error == nil else {
//                        currentErrors.append(customError)
//                        dispatchGroup.leave()
//                        return
//                    }
//
//                    guard let subdocuments = subquerySnapshot?.documents else {
//                        // Leave dispatch group if there's an error
////                        currentErrors?.append(customError)
//                        dispatchGroup.leave()
//                        return
//                    }
//
//                    for subdocument in subdocuments {
//                        // Работа с каждым поддокументом из подколлекции
//                        let subDocumentData = subdocument.data()
//
//                        let name = subDocumentData["name"] as? String
//                        let mall = subDocumentData["mall"] as? String
//                        let floor = subDocumentData["floor"] as? String
//                        let refImage = subDocumentData["refImage"] as? String
//                        let telefon = subDocumentData["telefon"] as? String
//                        let webSite = subDocumentData["webSite"] as? String
//                        let magazine = Shop(name: name, mall: mall, floor: floor, refImage: refImage, telefon: telefon, webSite: webSite)
//                        shops.append(magazine)
//                    }
//                    // Leave dispatch group after processing each subdocument
//                    dispatchGroup.leave()
//                }
//            }
//
//            dispatchGroup.notify(queue: .main) {
//                // Call completion only after all async operations have completed
//                if currentErrors.count != 0 {
//                    print("Returne message for analitic FB Crashlystics error")
//                }
//                completion(shops, currentErrors.first)
//            }
//        }
//    }
//    //                let documentData = document.data()
//    //                // Доступ к полям данных по мере необходимости
//    //                let magazineName = documentData["brandShop"] as? String
//    //                print("m
//                db.collection("productsMan").document(brandShop).collection("products").whereField("category", isEqualTo: "your_category").getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        print("Ошибка при получении документов: \(error)")
//                        dispatchGroup.leave()
//                        return
//                    }

//                    guard let productsDocuments = querySnapshot?.documents else {
//                        print("Документы не найдены")
//                        dispatchGroup.leave()
//                        return
//                    }
//
//                    // Обработка каждого найденного документа
//                    for productDocument in productsDocuments {
//                        let productName = productDocument.documentID
//                        filteredDocuments.append("\(brandShop)/\(productName)")
//                    }

//func observeAllMagazines(completion: @escaping ([Magazine]?, Error?) -> Void) {
//        let collectionRef = firestore.collection("Magazines")
//        // Добавить наблюдатель за изменениями
//        listener = collectionRef.addSnapshotListener { (querySnapshot, error) in
//            var magazines = [Magazine]()
//            guard let documents = querySnapshot?.documents else {
//                print("Ошибка при получении документов: \(error!)")
//                completion(magazines,error)
//                return
//            }
//
//            // Обработка каждого документа
//            for document in documents {
//                let documentData = document.data()
//                // Доступ к полям данных по мере необходимости
//                let magazineName = documentData["magazine"] as? String
//                print("magazineName - \(String(describing: magazineName))")
//
//
//                // Обработка подколлекций (если есть)
//                let subcollectionRef = document.reference.collection("products")
//                subcollectionRef.getDocuments { (subCollectionQuerySnapshot, error) in
//                    guard let subDocuments = subCollectionQuerySnapshot?.documents else {
//                        print("Ошибка при получении поддокументов: \(error!)")
//                        completion(magazines,error)
//                        return
//                    }
//
//                    for subDocument in subDocuments {
//                        // Работа с каждым поддокументом из подколлекции
//                        let subDocumentData = subDocument.data()
//
//                        let name = subDocumentData["name"] as? String
//                        let mall = subDocumentData["mall"] as? String
//                        let floor = subDocumentData["floor"] as? String
//                        let refImage = subDocumentData["refImage"] as? String
//                        let telefon = subDocumentData["telefon"] as? String
//                        let webSite = subDocumentData["webSite"] as? String
//                        let magazine = Magazine(name: name, mall: mall, floor: floor, refImage: refImage, telefon: telefon, webSite: webSite)
//                        magazines.append(magazine)
//
//                    }
//                }
//
//            }
//            completion(magazines,nil)
//        }
//    }



//            for document in querySnapshot!.documents {
//                let documentID = document.documentID
////                let documentRef = document.reference
//
//                let refMagazine = collectionRef.document(documentID).collection("products")
//
//            }

//    class ManagerFB {
//        let firestore = Firestore.firestore()
//
//        func observeAllObjects(completion: @escaping ([Object]?, Error?) -> Void) {
//            let collectionRef = firestore.collection("Magazines")
//
//            collectionRef.getDocuments { querySnapshot, error in
//                if let error = error {
//                    completion(nil, error)
//                    return
//                }
//
//                var objects = [Object]()
//
//                for document in querySnapshot!.documents {
//                    let documentID = document.documentID
//                    let documentRef = document.reference
//
//                    documentRef.collections { collectionRefs, collectionError in
//                        // Обработка ошибок получения коллекций
//                        if let collectionError = collectionError {
//                            completion(nil, collectionError)
//                            return
//                        }
//
//                        // Обойти каждую подколлекцию
//                        for subCollectionRef in collectionRefs {
//                            let subCollectionID = subCollectionRef.documentID
//
//                            // Получить документы в подколлекции
//                            subCollectionRef.getDocuments { subQuerySnapshot, subError in
//                                // Обработка ошибок подзапроса
//                                if let subError = subError {
//                                    completion(nil, subError)
//                                    return
//                                }
//
//                                // Парсинг данных объектов из подколлекции
//                                for subDocument in subQuerySnapshot!.documents {
//                                    let data = subDocument.data()
//                                    if let object = parseObject(data: data) {
//                                        objects.append(object)
//                                    }
//                                }
//
//                                completion(objects, nil)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        private func parseObject(data: [String: Any]) -> Object? {
//            // Парсинг данных объекта
//            // ...
//            return nil
//        }
//    }





//    func saveDeletedFromCart(products: [PopularProduct]) {
//
//        guard let currentUser = currentUser else { return }
//
//        if currentUser.isAnonymous, products.count > 0 {
//
//            let encoder = JSONEncoder()
//            let uid = currentUser.uid
//
//            let refFBR = Database.database().reference()
//            refFBR.child("usersAccaunt/\(uid)").setValue(["uidAnonymous":uid])
//            var removeCartProduct: [String:AddedProduct] = [:]
//
//            products.forEach { (cartProduct) in
//                let productEncode = AddedProduct(product: cartProduct)
//                print("cartProduct - \(productEncode)")
//                removeCartProduct[cartProduct.model] = productEncode
//            }
//
//            removeCartProduct.forEach { (addedProduct) in
//                do {
//                    let data = try encoder.encode(addedProduct.value)
//                    let json = try JSONSerialization.jsonObject(with: data)
//                    let ref = Database.database().reference(withPath: "usersAccaunt/\(uid)/AddedProducts")
//                    ref.updateChildValues([addedProduct.key:json]) { (error, reference) in
//                        if error != nil {
//                            self.collectorFailedMethods.isFailedSaveDeletedFromCart = true
//                            print("collectorFailedMethods.isFailedSaveDeletedFromCart error - \(String(describing: error))")
//                        }
//                    }
//
//                } catch {
//                    self.collectorFailedMethods.isFailedSaveDeletedFromCart = true
//                    print("collectorFailedMethods.isFailedSaveDeletedFromCart error - \(String(describing: error))")
//                }
//            }
//
//        }
//    }
    
//    func sendPasswordReset(email: String, _ callBack: @escaping (StateCallback) -> Void) {
//        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
//            if error != nil {
//                callBack(.failed)
//            } else {
//                Auth.auth().currentUser?.reload(completion: { error in
//                    if error != nil {
//                        print("Error currentUser?.reload(completion func sendPasswordReset( - \(String(describing: error))")
//                    }
//                    self.currentUser = Auth.auth().currentUser
//                })
//                callBack(.success)
//            }
//        }
//    }

//    func removeAvatarFromCurrentUser(_ callback: @escaping (StorageErrorCodeState) -> Void) {
//        // Если по какой то причине avatarRef = nil вызов метода avatarRef?.delete будет проигнорирован
//        if let avatarRef = avatarRef {
//            avatarRef.delete(completion: { error in
//
//                if let error = error as? StorageErrorCode {
//                    switch error {
//
//                    case .unauthenticated:
//                        callback(.unauthenticated)
//                    case .unauthorized:
//                        callback(.unauthorized)
//                    case .retryLimitExceeded:
//                        callback(.retryLimitExceeded)
//                    case .downloadSizeExceeded:
//                        callback(.downloadSizeExceeded)
//                    default:
//                        callback(.failed)
//                    }
//                } else {
//                    self.avatarRef = nil
//                    self.resetProfileChangeRequest(reset: .photoURL) { error in
//                        if error != nil {
//                            self.collectorFailedMethods.isFailedChangePhotoURLUser = true
//                            print("func removeAvatarFromCurrentUser Returne message for analitic FB Crashlystics error != nil -  \(String(describing: error))")
//                        }
//                        callback(.success)
//                    }
//                }
//            })
//        } else {
//            callback(.failed)
//            print("func removeAvatarFromCurrentUser - Returne message for analitic FB Crashlystics")
//        }
//    }

//    func addUidFromCurrentUserAccount() {
//        guard let currentUser = currentUser else {
//            return
//        }
//        let refFBR = Database.database().reference()
//        refFBR.child("usersAccaunt/\(currentUser.uid)").setValue(["uidCurrentUser":currentUser.uid])
//    }

//    func addProductsToANonRemoteUser(products: [String:Any]) {
//        guard let currentUser = currentUser else {
//            return
//        }
//        let ref = Database.database().reference(withPath: "usersAccaunt/\(currentUser.uid)/AddedProducts")
////        ref.updateChildValues(products)
//        ref.updateChildValues(products) { (error, reference) in
//            if error != nil {
//                // можно сохранить в UserDefaults и при следующем появлении инета повторить попытку!
//                print("ref.updateChildValues(products)  - \(String(describing: error))")
//                if let jsonData = try? JSONSerialization.data(withJSONObject: products, options: []) {
//                    self.defaults.set(jsonData, forKey: currentUser.uid)
//                }
//            }
//        }
//    }


//    func deleteAnonymusUSer(anonymusUser:User) {
//
//
//        anonymusUser.delete { (error) in
//            if error != nil {
//            } else {
//            }
//        }
//    }
    
//    func signIn(email: String, password: String, callBack: @escaping (AuthErrorCodeState) -> Void) {
//
//        guard let currentUser = currentUser else {
//            return
//        }
//
//        if currentUser.isAnonymous, cartProducts.count > 0 {
//            let uidUser = currentUser.uid
//            Database.database().reference().child("usersAccaunt").child(uidUser).removeValue { (error, reference) in
//                if error != nil {
//                    // не будем мешать пользователю регистрации если он сможет
//                    // нужно оповестить админа о том что этот uidUser не смог удалить корзину
//                    self.collectorFailedMethods.isFailedRemoveCartProductsAnonymousUser = uidUser
//                    print("isFailedRemoveCartProductsAnonymousUser - \(String(describing: error))")
//                }
//
//            }
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//
//            if let error = error as? AuthErrorCode {
//
//                switch error.code {
//
//                case .invalidEmail:
//                    callBack(.invalidEmail)
//                case .wrongPassword:
//                    callBack(.wrongPassword)
//                case .tooManyRequests:
//                    callBack(.tooManyRequests)
//                case .networkError:
//                    callBack(.networkError)
//                case .userTokenExpired:
//                    callBack(.userTokenExpired)
//                case .requiresRecentLogin:
//                    callBack(.requiresRecentLogin)
//                case .userDisabled:
//                    callBack(.userDisabled)
//                default:
//                    callBack(.failed)
//                }
//            } else {
//                if currentUser.isAnonymous {
//                    currentUser.delete { error in
//                        print("Error func signIn  - \(String(describing: error))")
//                        if error != nil {
//                            self.collectorFailedMethods.isFailedDeleteIsAnonymousUser = true
//                        }
//                    }
//                }
//                callBack(.success)
//            }
//        }
//    }

//    func signIn(email: String, password: String, callBack: @escaping (SignInCallback) -> Void) {
//
//        guard let currentUser = currentUser else {
//            return
//        }
//
//        if currentUser.isAnonymous {
//            let uidUser = currentUser.uid
//            print("currentUser.isAnonymous - Database.database().reference().child().child(uidUser).removeValue()")
//            Database.database().reference().child("usersAccaunt").child(uidUser).removeValue()
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//
//            if let error = error as? AuthErrorCode {
//
//                switch error.code {
//
//                case .invalidEmail:
//                    callBack(.invalidEmail)
//                case .wrongPassword:
//                    callBack(.invalidPassword)
//                default:
//                    callBack(.wentWrong)
//                }
//            } else {
//                if currentUser.isAnonymous {
//                    print("func signIn - currentUser.isAnonymous")
//                    currentUser.delete { (error) in
//                        print("Error - \(String(describing: error))")
//                    }
//                }
//                callBack(.success)
//            }
//        }
//    }
//    Auth.auth().currentUser?.reload(completion: { error in
    //                    if error != nil {
    //                        print("Error currentUser?.reload(completion func sendPasswordReset( - \(String(describing: error))")
    //                    } else {
    //                        print("Auth.auth().currentUser?.reload - Auth.auth().currentUser - \(String(describing: Auth.auth().currentUser))")
    //                        self.currentUser = Auth.auth().currentUser
    //                    }
    //
    //                })

//    func registerUserSignUpVC(email: String, password: String, name: String, completion: @escaping (AuthErrorCodeState) -> Void) {
//
//        guard let currentUser = currentUser else {
//            return
//        }
//
//        if currentUser.isAnonymous {
//
//            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//            currentUser.link(with: credential) { [weak self] (result, error) in
//
//                if let error = error as? AuthErrorCode {
//
//                    switch error.code {
//
//                    case . providerAlreadyLinked:
//                        callBack(. providerAlreadyLinked)
//                    case . credentialAlreadyInUse:
//                        callBack(. credentialAlreadyInUse)
//                    case .tooManyRequests:
//                        callBack(. tooManyRequests)
//                    default:
//                        callBack(.default)
//                    }
//                }
//
//
//                guard let user = result?.user else {
//                    completion(.failure(.somethingWentWrong))
//                    return
//                }
//
//                self?.currentUser = user
//
//                self?.createProfileChangeRequestSignUp(name: name, { [weak self] (state) in
//                    let uid = user.uid
//                    let refFBR = Database.database().reference()
//                    refFBR.child("usersAccaunt/\(uid)").updateChildValues(["uidPermanent":user.uid])
//                    refFBR.child("usersAccaunt/\(uid)/uidAnonymous").setValue(nil)
//                    self?.verificationEmailSignUp()
//                    completion(.success)
//                })
//
////                let uid = user.uid
////                let refFBR = Database.database().reference()
////                refFBR.child("usersAccaunt/\(uid)").updateChildValues(["uidPermanent":user.uid])
////                refFBR.child("usersAccaunt/\(uid)/uidAnonymous").setValue(nil)
////                self?.verificationEmailSignUp()
////                completion(.success)
//            }
//        } else {
//
//            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
//
//                guard error == nil else {
//
//                    if let error = error as? AuthErrorCode {
//
//                        switch error.code {
//                        case .emailAlreadyInUse:
//                            completion(.failure(.emailAlreadyInUse))
//                            return
//                        case .invalidEmail:
//                            completion(.failure(.invalidEmail))
//                            return
//                        case .wrongPassword:
//                            completion(.failure(.wrongPassword))
//                            return
//                        case .weakPassword:
//                            completion(.failure(.weakPassword))
//                            return
//                        default:
//                            completion(.failure(.somethingWentWrong))
//                            return
//                        }
//                    } else {
//                        completion(.failure(.somethingWentWrong))
//                        return
//                    }
//                }
//
//                guard let user = result?.user else {
//                    completion(.failure(.somethingWentWrong))
//                    return
//                }
//
////                self?.createProfileChangeRequestSignUp(name: name)
//                self?.createProfileChangeRequestSignUp(name: name, { [weak self] (state) in
//                    let uid = user.uid
//                    let refFBR = Database.database().reference()
//                    refFBR.child("usersAccaunt/\(uid)").setValue(["uidPermanent":user.uid])
//                    self?.verificationEmailSignUp()
//                    completion(.success)
//                })
////                let uid = user.uid
////                let refFBR = Database.database().reference()
////                refFBR.child("usersAccaunt/\(uid)").setValue(["uidPermanent":user.uid])
////                self?.verificationEmailSignUp()
////                completion(.success)
//            }
////
//        }
//    }
    
    // мы не можем из этого метода выслать .failed(error) так как accaunt будет создан на FB
    
//    func createProfileChangeRequestSignUp(name: String? = nil, photoURL: URL? = nil,_ callBack: @escaping (StateCallback) -> Void) {
//
//        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
//            if let name = name {
//                request.displayName = name
//            }
//
//            if let photoURL = photoURL {
//                request.photoURL = photoURL
//            }
//
//            request.commitChanges { error in
//                if error != nil {
//                    callBack(.failed)
//                    print("$$$$createProfileChangeRequest .failure!")
////                    callBack?(error)
//                } else {
//                    print("$$$$createProfileChangeRequest .success!")
//                    callBack(.success)
//                    // configure profile success
////                    self.delegate?.anonymousUserDidRegistered?()
//                }
//            }
//        }
//    }
//    func createProfileChangeRequestSignUp(name: String? = nil, photoURL: URL? = nil,_ callBack: ((Error?) -> Void)? = nil) {
//
//        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
//            if let name = name {
//                request.displayName = name
//            }
//
//            if let photoURL = photoURL {
//                request.photoURL = photoURL
//            }
//
//            request.commitChanges { error in
//                if error != nil {
//                    print("$$$$createProfileChangeRequest .failure!")
////                    callBack?(error)
//                } else {
//                    print("$$$$createProfileChangeRequest .success!")
//                    // configure profile success
////                    self.delegate?.anonymousUserDidRegistered?()
//                }
//            }
//        }
//    }

//    func removeAvatarFromCurrentUser(_ callback: @escaping (StateCallback, Bool) -> Void) {
//        avatarRef?.delete(completion: { error in
//            if error == nil {
//                self.avatarRef = nil
//                self.resetProfileChangeRequest(reset: .photoURL) { error in
//                }
//                callback(.success, false)
//            } else {
//                if let error = error as? StorageErrorCode {
//                    switch error {
//                    case .unauthenticated:
//                        callback(.failed, true)
//                    default:
//                        callback(.failed, false)
//                    }
//                } else {
//                    callback(.failed, false)
//                }
//            }
//        })
//    }



//                        if let url = url{
//                            self.avatarRef = profileImgReference
//                            self.createProfileChangeRequest(photoURL: url) { (error) in
//                                // если сдесь произошла ошибка что делать с image в storage и urlRefDelete?
//                                callback?(error)
//                            }
//                        }else{
//                            callback?(error)
//                        }


/*
 user.updateEmail(to: email)
 
 Примечание
 
 Может произойти сбой, если уже существует учетная запись с этим адресом электронной почты, созданная с использованием проверки подлинности по электронной почте и паролю.
 Примечание
 
 Возможные коды ошибок:
 + `AuthErrorCodeInvalidRecipientEmail` — указывает, что в запросе был отправлен неверный адрес электронной почты получателя. + `AuthErrorCodeInvalidSender` — указывает, что для этого действия в консоли задан неверный адрес электронной почты отправителя. + `AuthErrorCodeInvalidMessagePayload` — указывает на недопустимый шаблон электронной почты для отправки электронной почты с обновлением. + `AuthErrorCodeEmailAlreadyInUse` — указывает, что электронная почта уже используется другой учетной записью. + `AuthErrorCodeInvalidEmail` — указывает, что адрес электронной почты имеет неверный формат. + `AuthErrorCodeRequiresRecentLogin` — обновление электронной почты пользователя является важной операцией с точки зрения безопасности, для которой требуется недавний вход пользователя в систему. Эта ошибка указывает на то, что пользователь не входил в систему достаточно давно. Чтобы решить эту проблему, повторите аутентификацию пользователя, вызвав `reauthenticate(with:)`.
 Примечание
 
 См. AuthErrors для списка кодов ошибок, общих для всех пользовательских методов.
 Параметры
 
 Эл. адрес
 Электронный адрес пользователя.
 завершение
 По выбору; блок, вызываемый после завершения изменения профиля пользователя. Вызывается асинхронно в основном потоке в будущем.
 -
 Без описания.
 */


//            let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).jpeg")
//            _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
//                if let error = error {
//                    callback?(error, .image)
//                } else {
//                    profileImgReference.downloadURL(completion: { (url, error) in
//                        if let url = url{
//                            self.urlRefDelete = profileImgReference
//                            self.createProfileChangeRequest(photoURL: url) { (error) in
//                                if error == nil {
//                                    self.createProfileChangeRequest(name: name) { (error) in
//                                        print("Сработал createProfileChangeRequest(name: name)")
//                                        if error == nil {
//                                            print("createProfileChangeRequest(name: name)")
//                                            callback?(error, .success)
//                                        } else {
//                                            callback?(error, .name)
//                                        }
//                                    }
//                                } else {
//                                    callback?(error, .image)
//                                }
//                            }
//                        }else{
//                            callback?(error, .image)
//                        }
//                    })
//                }
//            }


//    func imageChangeRequest(_ callback: (Error?, StateProfileInfo) -> Void) {
//
//        let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).jpeg")
//        _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
//            if let error = error {
//                callback?(error)
//            } else {
//                profileImgReference.downloadURL(completion: { (url, error) in
//                    if let url = url{
//                        self.urlRefDelete = profileImgReference
//                        self.createProfileChangeRequest(name: name, photoURL: url) { (error) in
//                            callback?(error)
//                        }
//                    }else{
//                        callback?(error)
//                    }
//                })
//            }
//        }
//    }




//     for oldHVC
//    func getPreviewMalls(completionHandler: @escaping ([PreviewCategory]) -> Void) {
//        let databaseRef = Database.database().reference()
//        databaseRef.child("previewMalls").observe(.value) { snapshot in
//            var arrayMalls = [PreviewCategory]()
//            for item in snapshot.children {
//                let mall = item as! DataSnapshot
//                let model = PreviewCategory(snapshot: mall)
//                arrayMalls.append(model)
//            }
//            completionHandler(arrayMalls)
//        }
//    }
//
//    func getPreviewBrands(completionHandler: @escaping ([PreviewCategory]) -> Void) {
//        let databaseRef = Database.database().reference()
//        databaseRef.child("previewBrands").observe(.value) { snapshot in
//            var arrayBrands = [PreviewCategory]()
//            for item in snapshot.children {
//                let brand = item as! DataSnapshot
//                let model = PreviewCategory(snapshot: brand)
//                arrayBrands.append(model)
//            }
//            completionHandler(arrayBrands)
//        }
//    }
//
//    func getPopularProduct(completionHandler: @escaping ([PopularProduct]) -> Void) {
//        let databaseRef = Database.database().reference()
//        databaseRef.child("PopularProductMan").observe(.value) { snapshot in
//            var arrayProduct = [PopularProduct]()
//
//            for item in snapshot.children {
//                let product = item as! DataSnapshot
//
//                var arrayMalls = [String]()
//                var arrayRefe = [String]()
//
//
//                for mass in product.children {
//                    let item = mass as! DataSnapshot
//
//                    switch item.key {
//                    case "malls":
//                        for it in item.children {
//                            let item = it as! DataSnapshot
//                            if let refDictionary = item.value as? String {
//                                arrayMalls.append(refDictionary)
//                            }
//                        }
//
//                    case "refImage":
//                        for it in item.children {
//                            let item = it as! DataSnapshot
//                            if let refDictionary = item.value as? String {
//                                arrayRefe.append(refDictionary)
//                            }
//                        }
//                    default:
//                        break
//                    }
//
//                }
//                let productModel = PopularProduct(snapshot: product, refArray: arrayRefe, malls: arrayMalls)
//                arrayProduct.append(productModel)
//            }
//            completionHandler(arrayProduct)
//        }
//    }
    
    
// newHVC
    
//    func getPreviewMallsNew(completionHandler: @escaping ([ItemCell]) -> Void) {
//        let databaseRef = Database.database().reference()
//        databaseRef.child("PreviewMallMan").observe(.value) { snapshot in
//            var arrayMalls = [ItemCell]()
//            for item in snapshot.children {
//                let mall = item as! DataSnapshot
//                let modelFB = PreviewCategory(snapshot: mall)
//                let modelDataSource = ItemCell(malls: modelFB, brands: nil, popularProduct: nil, mallImage: nil)
//                arrayMalls.append(modelDataSource)
//            }
//            completionHandler(arrayMalls)
//        }
//    }
//
//    func getPreviewBrandsNew(completionHandler: @escaping ([ItemCell]) -> Void) {
//        let databaseRef = Database.database().reference()
//        databaseRef.child("PreviewBrandMan").observe(.value) { snapshot in
//            var arrayBrands = [ItemCell]()
//            for item in snapshot.children {
//                let brand = item as! DataSnapshot
////                print("PreviewBrandMan - \(brand)")
//                let modelFB = PreviewCategory(snapshot: brand)
//                let modelDataSource = ItemCell(malls: nil, brands: modelFB, popularProduct: nil, mallImage: nil)
//                arrayBrands.append(modelDataSource)
//            }
//            completionHandler(arrayBrands)
//        }
//    }
//
//    func getPopularProductNew(completionHandler: @escaping ([ItemCell]) -> Void) {
//        let databaseRef = Database.database().reference()
//        databaseRef.child("PopularProductMan").observe(.value) { snapshot in
//            var arrayProduct = [ItemCell]()
//
//            for item in snapshot.children {
//                let product = item as! DataSnapshot
//
//                var arrayMalls = [String]()
//                var arrayRefe = [String]()
//
//
//                for mass in product.children {
//                    let item = mass as! DataSnapshot
//
//                    switch item.key {
//                    case "malls":
//                        for it in item.children {
//                            let item = it as! DataSnapshot
//                            if let refDictionary = item.value as? String {
//                                arrayMalls.append(refDictionary)
//                            }
//                        }
//
//                    case "refImage":
//                        for it in item.children {
//                            let item = it as! DataSnapshot
//                            if let refDictionary = item.value as? String {
//                                arrayRefe.append(refDictionary)
//                            }
//                        }
//                    default:
//                        break
//                    }
//
//                }
//                let modelFB = PopularProduct(snapshot: product, refArray: arrayRefe, malls: arrayMalls)
//                let modelDataSource = ItemCell(malls: nil, brands: nil, popularProduct: modelFB, mallImage: nil)
//                arrayProduct.append(modelDataSource)
//            }
//            completionHandler(arrayProduct)
//        }
//    }

