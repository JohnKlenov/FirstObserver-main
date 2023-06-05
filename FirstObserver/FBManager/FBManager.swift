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

//(success: Bool)

enum StateProfileInfo {

    case success
    case failed(image:Bool? = nil, name:Bool? = nil)
    case nul
}

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

enum StateCallback {
    case success
    case failed
}

enum StateDeleteAccaunt {
    case success
    case failed
    case failedRequiresRecentLogin
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

// в productCell поиграть с приоритетами и >= для constraint
final class FBManager {

    static let shared = FBManager()
    var currentUser: User?
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
    
    let defaults = UserDefaults.standard
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
    
    func addProductInBaseData(nameProduct:String, json: Any) {
        let ref = Database.database().reference(withPath: "usersAccaunt/\(currentUser?.uid ?? "")/AddedProducts")
        ref.updateChildValues([nameProduct : json])
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
//                    print("Append new product BrandsViewController\(productModel.model)")
                    
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
            guard let user = authResult?.user else {return}
            let uid = user.uid
            databaseRef.child("usersAccaunt/\(uid)").setValue(["uidAnonymous":user.uid])
        }
    }
    
    func removeObserverForCartProductsUser() {
        if let refHandle = refHandleCart, let currentUser = currentUser {
//            print("func removeObserverForCartProductsUser()")
            Database.database().reference().child("usersAccaunt/\(currentUser.uid)").removeObserver(withHandle: refHandle)
//            self.refHandle = nil
        }
    }

    func getCartProduct(completionHandler: @escaping ([PopularProduct]) -> Void) {

        guard let currentUser = currentUser else {
            completionHandler([])
            return
        }
        refHandleCart = Database.database().reference().child("usersAccaunt/\(currentUser.uid)").observe(.value) { (snapshot) in
//            print(".observe(.value) { (snapshot) - \(String(describing: self.currentUser?.uid))")
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
    
    
    
    

    func getImagefromStorage(refImage:String, completionHandler: @escaping (UIImage) -> Void) {
        let ref = Storage.storage().reference(forURL: refImage)
        let megaBite = Int64(1*1024*1024)
        ref.getData(maxSize: megaBite) { (data, error) in
            guard let imageData = data else {
                let defaultImage = UIImage(named: "DefaultImage")!
                completionHandler(defaultImage)
                return
            }
            if let image = UIImage(data: imageData) {
                completionHandler(image)
            }
        }
    }


    // MARK: - NewProfileViewController -
    
    func updateProfileInfo(withImage image: Data? = nil, name: String? = nil, _ callback: ((StateProfileInfo) -> ())? = nil) {
        guard let user = currentUser else {
            return
        }

        if let image = image{
            imageChangeRequest(user: user, image: image) { (error) in
                let imageIsFailed = error != nil ? true: false
                self.createProfileChangeRequest(name: name) { (error) in
                    let nameIsFailed = error != nil ? true: false
                    if !imageIsFailed, !nameIsFailed {
                        callback?(.success)
                    } else {
                        callback?(.failed(image: imageIsFailed, name: nameIsFailed))
                    }
                }
            }
        } else if let name = name {
            self.createProfileChangeRequest(name: name) { error in
                let nameIsFailed = error != nil ? true: false
                if !nameIsFailed {
                    callback?(.success)
                } else {
                    callback?(.failed(name: nameIsFailed))
                }
            }
        } else {
            callback?(.nul)
        }
    }

    func imageChangeRequest(user:User, image:Data,  _ callback: ((Error?) -> ())? = nil) {
        // если пытаемся добавить image когда нет wifi
        // при Database.database().isPersistenceEnabled = true error в profileImgReference.putData не возвращается ждет сети
            let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).jpeg")
            _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("не удалось запулить data на сервак")
                    callback?(error)
                } else {
                    profileImgReference.downloadURL(completion: { (url, error) in
                        if let url = url{
                            self.avatarRef = profileImgReference
                            self.createProfileChangeRequest(photoURL: url) { (error) in
                                // если сдесь произошла ошибка что делать с image в storage и urlRefDelete?
                                callback?(error)
                            }
                        }else{
                            callback?(error)
                        }
                    })
                }
            }
        }


    func createProfileChangeRequest(name: String? = nil, photoURL: URL? = nil,_ callBack: ((Error?) -> Void)? = nil) {

        print("createProfileChangeRequest")
        if let request = currentUser?.createProfileChangeRequest() {
            if let name = name {
                request.displayName = name
            }

            if let photoURL = photoURL {
                request.photoURL = photoURL
            }

            request.commitChanges { error in
                print("request.commitChanges ")
                    callBack?(error)
            }
        }
    }

    func resetProfileChangeRequest(reset: ResetProfile,_ callBack: ((Error?) -> Void)? = nil) {

        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {

            switch reset {

            case .name:
                request.displayName = nil
            case .photoURL:
                request.photoURL = nil
            }
            request.commitChanges { error in
                callBack?(error)
            }
        }
    }
    func removeAvatarFromDeletedUser() {

        avatarRef?.delete(completion: { error in
                self.avatarRef = nil
        })
    }
    func removeAvatarFromCurrentUser(_ callback: @escaping (StateCallback) -> Void) {
        avatarRef?.delete(completion: { error in
            if error == nil {
                self.avatarRef = nil
                self.resetProfileChangeRequest(reset: .photoURL) { error in
                    if error != nil {
                        print("Не удалось удалить старую photoURL в currentUser")
//                        callback(.failed)
//                        return
                    }
                }
                callback(.success)
            } else {
                callback(.failed)
            }
        })
    }

    func addUidFromCurrentUserAccount() {
        guard let currentUser = currentUser else {
            return
        }
        let refFBR = Database.database().reference()
        refFBR.child("usersAccaunt/\(currentUser.uid)").setValue(["uidCurrentUser":currentUser.uid])
    }

    func addProductsToANonRemoteUser(products: [String:Any]) {
        guard let currentUser = currentUser else {
            return
        }
        let ref = Database.database().reference(withPath: "usersAccaunt/\(currentUser.uid)/AddedProducts")
        ref.updateChildValues(products)
    }

    func cacheImageRemoveMemoryAndDisk(imageView: UIImageView) {
        if let cacheKey = imageView.sd_imageURL?.absoluteString {
            SDImageCache.shared.removeImageFromDisk(forKey: cacheKey)
            SDImageCache.shared.removeImageFromMemory(forKey: cacheKey)
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

    func signOut(_ callback: (StateCallback) -> Void) {
        do {
            try Auth.auth().signOut()
            callback(.success)
        } catch {
            // AuthErrorCodeKeychainError` — Указывает, что произошла ошибка при доступе к цепочке ключей. Поле NSLocalizedFailureReasonErrorKey в словаре userInfo будет содержать дополнительную информацию
            callback(.failed)
        }
    }

    func deleteAccaunt(_ callback: @escaping (StateDeleteAccaunt) -> Void) {

        guard let user = currentUser else {return}

        user.delete { (error) in
            if let error = error as? AuthErrorCode {
                switch error.code {
                case .requiresRecentLogin:
                    callback(.failedRequiresRecentLogin)
                default:
                    callback(.failed)
                }
            } else {
                callback(.success)
            }
        }
    }

    func deleteCurrentUserProducts() {
        if let user = currentUser {
            let uid = user.uid
            Database.database().reference().child("usersAccaunt").child(uid).removeValue()
        }
    }

    func reauthenticateUser(password: String, callback: @escaping (StateReauthenticateUser) -> Void) {
        guard let user = currentUser, let email = user.email else {return}

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        user.reauthenticate(with: credential) { (result, error) in
            if let error = error as? AuthErrorCode {
                switch error.code {
                case .wrongPassword:
                    callback(.wrongPassword)
                default:
                    callback(.failed)
                }
            } else {
                callback(.success)
            }
        }
    }

    
    // MARK: - NewSignInViewController -

//    func deleteAnonymusUSer(anonymusUser:User) {
//
//
//        anonymusUser.delete { (error) in
//            if error != nil {
//            } else {
//            }
//        }
//    }
    
    func signIn(email: String, password: String, callBack: @escaping (SignInCallback) -> Void) {
        
        guard let currentUser = currentUser else {
            return
        }
        
        if currentUser.isAnonymous {
            let uidUser = currentUser.uid
            Database.database().reference().child("usersAccaunt").child(uidUser).removeValue()
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error as? AuthErrorCode {
                
                switch error.code {
                    
                case .invalidEmail:
                    callBack(.invalidEmail)
                case .wrongPassword:
                    callBack(.invalidPassword)
                default:
                    callBack(.wentWrong)
                }
            } else {
                if currentUser.isAnonymous {
                    print("func signIn - currentUser.isAnonymous")
                    currentUser.delete { (error) in
                        print("Error currentUser.delete")
                    }
                }
                callBack(.success)
            }
        }
    }
    
    func saveDeletedFromCart(products: [PopularProduct]) {
        
        guard let currentUser = currentUser else { return }
        
        if currentUser.isAnonymous {
            
            let encoder = JSONEncoder()
            let uid = currentUser.uid

            let refFBR = Database.database().reference()
            refFBR.child("usersAccaunt/\(uid)").setValue(["uidAnonymous":uid])
            var removeCartProduct: [String:AddedProduct] = [:]

            products.forEach { (cartProduct) in
                let productEncode = AddedProduct(product: cartProduct)
                print("cartProduct - \(productEncode)")
                removeCartProduct[cartProduct.model] = productEncode
            }

            removeCartProduct.forEach { (addedProduct) in
                do {
                    let data = try encoder.encode(addedProduct.value)
                    let json = try JSONSerialization.jsonObject(with: data)
                    let ref = Database.database().reference(withPath: "usersAccaunt/\(uid)/AddedProducts")
                    ref.updateChildValues([addedProduct.key:json])

                } catch {
                    print("an error occured", error)
                }
            }
            
        }
    }
    
    func sendPasswordReset(email: String, _ callBack: @escaping (StateCallback) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                callBack(.failed)
            } else {
                callBack(.success)
            }
        }
    }
    
    
    // MARK: - NewSignUpViewController
    
    func registerUserSignUpVC(email: String, password: String, name: String, completion: @escaping (AuthResulSignUp) -> Void) {
        
        guard let currentUser = currentUser else {
            return
        }

        if currentUser.isAnonymous {
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            currentUser.link(with: credential) { [weak self] (result, error) in
                
                guard error == nil else {
                    completion(.failure(.somethingWentWrong))
                    return
                }
                
                guard let user = result?.user else {
                    completion(.failure(.somethingWentWrong))
                    return
                }
                
//                self?.createProfileChangeRequestSignUp(name:name)
                self?.createProfileChangeRequestSignUp(name: name, { [weak self] (state) in
                    let uid = user.uid
                    let refFBR = Database.database().reference()
                    refFBR.child("usersAccaunt/\(uid)").updateChildValues(["uidPermanent":user.uid])
                    refFBR.child("usersAccaunt/\(uid)/uidAnonymous").setValue(nil)
                    self?.verificationEmailSignUp()
                    completion(.success)
                })
                
//                let uid = user.uid
//                let refFBR = Database.database().reference()
//                refFBR.child("usersAccaunt/\(uid)").updateChildValues(["uidPermanent":user.uid])
//                refFBR.child("usersAccaunt/\(uid)/uidAnonymous").setValue(nil)
//                self?.verificationEmailSignUp()
//                completion(.success)
            }
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                
                guard error == nil else {
                    
                    if let error = error as? AuthErrorCode {
    
                        switch error.code {
                        case .emailAlreadyInUse:
                            completion(.failure(.emailAlreadyInUse))
                            return
                        case .invalidEmail:
                            completion(.failure(.invalidEmail))
                            return
                        case .wrongPassword:
                            completion(.failure(.wrongPassword))
                            return
                        case .weakPassword:
                            completion(.failure(.weakPassword))
                            return
                        default:
                            completion(.failure(.somethingWentWrong))
                            return
                        }
                    } else {
                        completion(.failure(.somethingWentWrong))
                        return
                    }
                }
                
                guard let user = result?.user else {
                    completion(.failure(.somethingWentWrong))
                    return
                }
                
//                self?.createProfileChangeRequestSignUp(name: name)
                self?.createProfileChangeRequestSignUp(name: name, { [weak self] (state) in
                    let uid = user.uid
                    let refFBR = Database.database().reference()
                    refFBR.child("usersAccaunt/\(uid)").setValue(["uidPermanent":user.uid])
                    self?.verificationEmailSignUp()
                    completion(.success)
                })
//                let uid = user.uid
//                let refFBR = Database.database().reference()
//                refFBR.child("usersAccaunt/\(uid)").setValue(["uidPermanent":user.uid])
//                self?.verificationEmailSignUp()
//                completion(.success)
            }
//            
        }
    }
    
    // мы не можем из этого метода выслать .failed(error) так как accaunt будет создан на FB
    
    func createProfileChangeRequestSignUp(name: String? = nil, photoURL: URL? = nil,_ callBack: @escaping (StateCallback) -> Void) {

        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
            if let name = name {
                request.displayName = name
            }

            if let photoURL = photoURL {
                request.photoURL = photoURL
            }

            request.commitChanges { error in
                if error != nil {
                    callBack(.failed)
                    print("$$$$createProfileChangeRequest .failure!")
//                    callBack?(error)
                } else {
                    print("$$$$createProfileChangeRequest .success!")
                    callBack(.success)
                    // configure profile success
//                    self.delegate?.anonymousUserDidRegistered?()
                }
            }
        }
    }
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
    
    
    // Отправить пользователю электронное письмо с подтверждением регистрации
    func verificationEmailSignUp() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                print("sendEmailVerification - Что то пошло не так!!!!")
            } else {
                print("sendEmailVerification - Мы отправили подтверждение на email")
            }
        })
    }
    
}


extension UIImageView {



    func fetchingImageWithPlaceholder(url: String, defaultImage: UIImage?) {
        let storage = Storage.storage()
        let urlRef = storage.reference(forURL: url)
        self.sd_setImage(with: urlRef, maxImageSize: 1024*1024, placeholderImage: defaultImage, options: .refreshCached) { (image, error, cashType, storageRef) in
            FBManager.shared.avatarRef = storageRef
            if error != nil {
                self.image = defaultImage
            }
        }
    }
}










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
